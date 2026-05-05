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
                
            case .multipleChoiceText, .multipleChoiceEmoji:
                if let selection = selectedOptions[question.id] {
                    let weight = question.riskWeights?[safe: selection.index] ?? 0
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
        
        let context = store.entries.suffix(5).flatMap { $0.responses }.map {
            "[\($0.dimension.rawValue)] \($0.questionText): \($0.textAnswer ?? $0.selectedOption ?? "sin respuesta") (peso: \($0.riskWeight))"
        }.joined(separator: "\n")
        
        let weights = store.selectionWeights()
        let typeHint = weights.max(by: { $0.value < $1.value })?.key.rawValue ?? "multipleChoiceEmoji"
        
        let prompt = """
        Eres un asistente especializado en detección de burnout laboral en empleados de Coppel.
        Genera exactamente 2 preguntas nuevas en español, en JSON, sin texto adicional.
        
        Historial reciente:
        \(context)
        
        El usuario prefiere preguntas de tipo "\(typeHint)".
        
        Tipos válidos: "openText", "multipleChoiceText", "multipleChoiceEmoji"
        Dimensiones válidas: "cargaLaboral", "agotamientoEmocional", "despersonalizacion", "realizacionPersonal", "indicadoresFisicos"
        
        Formato:
        [
          {
            "dimension": "<dimensión>",
            "type": "<tipo>",
            "text": "<pregunta>",
            "options": ["<op1>","<op2>","<op3>","<op4>"] // null si openText
          },
          { ... }
        ]
        Las opciones deben ir de mejor (índice 0) a peor estado (índice 3).
        Si el tipo es "multipleChoiceEmoji", cada opción debe comenzar con un emoji relevante.
        """
        
        do {
            let response = try await session.respond(to: prompt)
            if !parseAIQuestions(json: response.content) {
                loadNextQuestions()
            }
        } catch {
            loadNextQuestions()
        }
    }
    
    @discardableResult
    private func parseAIQuestions(json: String) -> Bool {
        // Limpiar posibles bloques de código markdown
        let clean = json
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = clean.data(using: .utf8),
              let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
              arr.count == 2
        else { return false }
        
        var parsed: [BurnoutQuestion] = []
        
        for obj in arr {
            guard let dimRaw = obj["dimension"] as? String,
                  let typeRaw = obj["type"] as? String,
                  let text = obj["text"] as? String,
                  let dimension = BurnoutDimension(rawValue: dimRaw),
                  let qType = QuestionType(rawValue: typeRaw)
            else { return false }
            
            let options = obj["options"] as? [String]
            let weights = qType == .openText ? nil : [0, 1, 2, 3]
            
            parsed.append(BurnoutQuestion(
                dimension: dimension,
                type: qType,
                text: text,
                options: options,
                riskWeights: weights
            ))
        }
        
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
