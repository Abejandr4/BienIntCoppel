import Foundation
import FoundationModels
internal import Combine

//es el que se encarga de mostrar el UI

@MainActor
class QuestionnaireViewModel: ObservableObject {
    
    // MARK: - Preguntas activas (siempre 2)
    @Published var activeQuestions: [BurnoutQuestion] = []
    
    // MARK: - Respuestas del usuario [questionID: respuesta]
    @Published var textAnswers: [UUID: String] = [:]
    @Published var selectedOptions: [UUID: (index: Int, text: String)] = [:]
    
    // MARK: - Estado UI
    @Published var isLoading = false
    @Published var isSaved = false
    @Published var errorMessage: String?
    @Published var usingAI = false
    
    // MARK: - Privado
    private let store: QuestionnaireStore
    private var aiAvailable = false
    private var session: LanguageModelSession?
    
    // Dimensiones ya vistas en las últimas N sesiones (para no repetir)
    private var recentDimensions: [BurnoutDimension] = []
    
    init(store: QuestionnaireStore) {
        self.store = store
        loadNextQuestions()
        Task { await setupAI() }
    }
    
    // MARK: - Cargar siguiente par de preguntas
    
    func loadNextQuestions() {
        let pair = selectQuestionPair()
        activeQuestions = pair
        textAnswers = [:]
        selectedOptions = [:]
        isSaved = false
    }
    
    // MARK: - Selección del par
    
    private func selectQuestionPair() -> [BurnoutQuestion] {
        
        // 1. Elegir 2 dimensiones distintas, priorizando las menos vistas
        let dim1 = pickDimension(excluding: [])
        let dim2 = pickDimension(excluding: [dim1])
        
        // 2. Para cada dimensión, elegir el tipo según preferencias del usuario
        let type1 = store.pickWeightedType()
        let type2 = store.pickWeightedType(excluding: type1) // segunda pregunta de tipo distinto
        
        let q1 = pickQuestion(dimension: dim1, preferredType: type1)
        let q2 = pickQuestion(dimension: dim2, preferredType: type2)
        
        // Actualizar historial de dimensiones recientes
        recentDimensions.append(contentsOf: [dim1, dim2])
        if recentDimensions.count > 6 { recentDimensions.removeFirst(2) }
        
        return [q1, q2]
    }
    
    /// Elige la dimensión con mayor necesidad de seguimiento,
    /// evitando repetir las recientes y priorizando las de mayor riesgo acumulado.
    private func pickDimension(excluding: [BurnoutDimension]) -> BurnoutDimension {
        let all = BurnoutDimension.allCases
        let recent = Set(recentDimensions.suffix(4))
        let excluded = Set(excluding)
        
        // Preferir dimensiones no vistas recientemente
        let candidates = all.filter { !recent.contains($0) && !excluded.contains($0) }
        let pool = candidates.isEmpty
        ? all.filter { !excluded.contains($0) }
        : candidates
        
        // Puntuar cada dimensión según riesgo acumulado en entradas recientes
        let riskScores = dimensionRiskScores()
        
        // Ordenar de mayor a menor riesgo y elegir con algo de aleatoriedad
        // (no siempre la de mayor riesgo, para no generar ansiedad por repetición)
        let sorted = pool.sorted { (riskScores[$0] ?? 0) > (riskScores[$1] ?? 0) }
        
        // 70 % elige la de mayor riesgo del pool, 30 % elige aleatoriamente
        if Double.random(in: 0..<1) < 0.7, let first = sorted.first {
            return first
        }
        return pool.randomElement() ?? .cargaLaboral
    }
    
    private func dimensionRiskScores() -> [BurnoutDimension: Int] {
        var scores: [BurnoutDimension: Int] = [:]
        let recent = store.entries.suffix(5)
        
        for entry in recent {
            for response in entry.responses {
                scores[response.dimension, default: 0] += response.riskWeight
            }
        }
        return scores
    }
    
    /// Elige la pregunta de la dimensión que más se acerque al tipo preferido.
    /// Si no hay de ese tipo en esa dimensión, usa cualquiera disponible.
    private func pickQuestion(dimension: BurnoutDimension,
                              preferredType: QuestionType) -> BurnoutQuestion {
        let pool = QuestionBank.questions(for: dimension)
        
        // Evitar repetir preguntas ya vistas recientemente
        let recentTexts = Set(store.entries.suffix(3).flatMap { $0.responses.map(\.questionText) })
        let fresh = pool.filter { !recentTexts.contains($0.text) }
        let candidates = fresh.isEmpty ? pool : fresh
        
        return candidates.first(where: { $0.type == preferredType })
        ?? candidates.randomElement()
        ?? pool[0]
    }
    
    // MARK: - Enviar respuestas
    
    func submitAndGenerate() async {
        let responses = buildResponses()
        guard !responses.isEmpty else { return }
        
        let entry = QuestionnaireEntry(
            id: UUID(),
            date: Date(),
            responses: responses
        )
        store.save(entry: entry)
        isSaved = true
        isLoading = true
        
        if aiAvailable {
            await generateWithAI()
        } else {
            loadNextQuestions()
        }
        
        isLoading = false
    }
    
    private func buildResponses() -> [QuestionResponse] {
        var result: [QuestionResponse] = []
        
        for question in activeQuestions {
            switch question.type {
            case .openText:
                let text = textAnswers[question.id] ?? ""
                // Incluir aunque esté vacío si la otra pregunta tiene respuesta
                result.append(QuestionResponse(
                    questionText: question.text,
                    questionType: question.type,
                    dimension: question.dimension,
                    textAnswer: text.isEmpty ? nil : text,
                    selectedOption: nil,
                    riskWeight: 0
                ))
                
            case .multipleChoiceText, .multipleChoiceEmoji, .emojiOnly:
                if let selection = selectedOptions[question.id] {
                    let weight = question.riskWeights?[selection.index] ?? 0
                    result.append(QuestionResponse(
                        questionText: question.text,
                        questionType: question.type,
                        dimension: question.dimension,
                        textAnswer: nil,
                        selectedOption: selection.text,
                        riskWeight: weight
                    ))
                } else {
                    // Sin respuesta: incluir con peso neutro
                    result.append(QuestionResponse(
                        questionText: question.text,
                        questionType: question.type,
                        dimension: question.dimension,
                        textAnswer: nil,
                        selectedOption: nil,
                        riskWeight: 0
                    ))
                }
            }
        }
        
        // Al menos una respuesta debe tener contenido
        let hasAnyContent = result.contains {
            $0.textAnswer != nil || $0.selectedOption != nil
        }
        return hasAnyContent ? result : []
    }
    
    var canSubmit: Bool {
        let hasText = textAnswers.values.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let hasOption = !selectedOptions.isEmpty
        return hasText || hasOption
    }
    
    // MARK: - Apple Intelligence
    
    private func setupAI() async {
        do {
            let probe = LanguageModelSession()
            _ = try await probe.respond(to: "ping")
            session = LanguageModelSession(tools: [GenerateQuestionsTool()])
            aiAvailable = true
            usingAI = true
        } catch {
            aiAvailable = false
            usingAI = false
        }
    }
    
    private func generateWithAI() async {
        guard let session else { loadNextQuestions(); return }
        
        // Construir contexto para el tool
        let recentResponses = store.entries.suffix(5).flatMap(\.responses)
        
        let dimensionSummary = Dictionary(grouping: recentResponses, by: \.dimension)
            .mapValues { responses in responses.map(\.riskWeight).reduce(0, +) }
            .sorted { $0.value > $1.value }
            .map { "\($0.key.rawValue): \($0.value)pts" }
            .joined(separator: ", ")
        
        let preferredType = store.selectionWeights()
            .max(by: { $0.value < $1.value })?.key.rawValue ?? "multipleChoiceEmoji"
        
        let recentDims = recentDimensions.suffix(4)
            .map(\.rawValue)
            .joined(separator: ", ")
        
        let contexto = """
            Dimensiones por nivel de riesgo acumulado: \(dimensionSummary.isEmpty ? "sin datos aún" : dimensionSummary).
            Respuestas recientes de texto: \(recentResponses.compactMap(\.textAnswer).suffix(3).joined(separator: " | ")).
            """
        
        // Prompt que instruye al modelo a llamar al tool
        let prompt = """
            Usa la herramienta generateQuestions para generar el siguiente par de preguntas.
            
            Contexto: \(contexto)
            Tipo preferido: \(preferredType)
            Dimensiones recientes a evitar: \(recentDims.isEmpty ? "ninguna" : recentDims)
            """
        
        do {
            let response = try await session.respond(to: prompt)
            
            // Buscar el resultado estructurado en el contenido de la respuesta
            // Foundation Models devuelve el texto; parseamos el JSON del tool use
            if !parseAIQuestions(from: response.content) {
                loadNextQuestions()
            }
        } catch {
            loadNextQuestions()
        }
    }
    
    // Convierte AIGeneratedQuestion → BurnoutQuestion
    private func parseAIQuestions(from content: String) -> Bool {
        // Limpiar posibles bloques markdown
        let clean = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = clean.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return false }
        
        // Intentar parsear como par { first: {}, second: {} }
        // o como array [ {}, {} ] (fallback)
        let rawQuestions: [[String: Any]]
        if let first = obj["first"] as? [String: Any],
           let second = obj["second"] as? [String: Any] {
            rawQuestions = [first, second]
        } else if let arr = try? JSONSerialization.jsonObject(
            with: clean.data(using: .utf8)!) as? [[String: Any]], arr.count == 2 {
            rawQuestions = arr
        } else {
            return false
        }
        
        var parsed: [BurnoutQuestion] = []
        
        for raw in rawQuestions {
            guard let dimRaw  = raw["dimension"] as? String,
                  let typeRaw = raw["type"] as? String,
                  let text    = raw["text"] as? String,
                  let dimension = BurnoutDimension(rawValue: dimRaw),
                  let qType   = QuestionType(rawValue: typeRaw)
            else { return false }
            
            let options = (raw["options"] as? [String])?.filter { !$0.isEmpty }
            let weights: [Int]? = {
                guard qType != .openText else { return nil }
                let count = options?.count ?? 0
                // Escala lineal 0…3 normalizada al número de opciones
                return (0..<count).map { i in
                    count > 1 ? Int(Double(i) / Double(count - 1) * 3.0) : 0
                }
            }()
            
            parsed.append(BurnoutQuestion(
                dimension: dimension,
                type: qType,
                text: text,
                options: options,
                riskWeights: weights
            ))
        }
        
        guard parsed.count == 2 else { return false }
        
        activeQuestions = parsed
        textAnswers = [:]
        selectedOptions = [:]
        isSaved = false
        return true
    }
    
}
// MARK: - Array safe subscript

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
