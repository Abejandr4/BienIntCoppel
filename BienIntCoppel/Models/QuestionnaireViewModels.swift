import Foundation
import FoundationModels
internal import Combine

@MainActor
class QuestionnaireViewModel: ObservableObject {
    
    // MARK: Pregunta activa
    @Published var multipleChoiceQuestion: String
    @Published var options: [String]
    @Published var openQuestion: String
    private var currentRiskWeights: [Int]
    
    // MARK: Respuestas del usuario
    @Published var selectedOption: String = ""
    @Published var selectedOptionIndex: Int = -1
    @Published var openAnswer: String = ""
    
    // MARK: Estado UI
    @Published var isLoading = false
    @Published var isSaved = false
    @Published var errorMessage: String?
    @Published var usingAI = false  // para mostrarle al usuario qué modo está activo
    
    private let store: QuestionnaireStore
    
    // FoundationModels: se inicializa solo si está disponible
    private var session: LanguageModelSession?
    private var aiAvailable = false
    
    // MARK: - Init
    
    init(store: QuestionnaireStore) {
        self.store = store
        
        // Cargar el par heurístico que corresponde a esta sesión
        let pair = QuestionBank.pair(forEntry: store.nextQuestionIndex)
        self.multipleChoiceQuestion = pair.multipleChoiceQuestion
        self.options = pair.options
        self.openQuestion = pair.openQuestion
        self.currentRiskWeights = pair.riskWeights
        
        // Intentar inicializar Apple Intelligence
        Task { await self.setupAI() }
    }
    
    // MARK: - Detección de Apple Intelligence
    
    private func setupAI() async {
        // SystemLanguageModel.default lanza error si el dispositivo
        // no soporta Foundation Models (iOS < 18.1 o sin Apple Intelligence)
        do {
            let model = SystemLanguageModel.default
            // Una llamada vacía para validar disponibilidad
            let probe = LanguageModelSession()
            _ = try await probe.respond(to: "ping")
            session = LanguageModelSession(tools: [GenerateQuestionsTool()])
            aiAvailable = true
            usingAI = true
        } catch {
            aiAvailable = false
            usingAI = false
            // Silencioso: el fallback heurístico ya está listo
        }
    }
    
    // MARK: - Guardar y generar siguiente ronda
    
    func submitAndGenerate() async {
        guard selectedOptionIndex >= 0,
              !openAnswer.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }
        
        let weight = currentRiskWeights[safe: selectedOptionIndex] ?? 0
        
        let entry = QuestionnaireEntry(
            id: UUID(),
            date: Date(),
            multipleChoiceQuestion: multipleChoiceQuestion,
            multipleChoiceAnswer: selectedOption,
            multipleChoiceRiskWeight: weight,
            openQuestion: openQuestion,
            openAnswer: openAnswer
        )
        store.save(entry: entry)
        isSaved = true
        
        isLoading = true
        
        if aiAvailable {
            await generateWithAI()
        } else {
            await generateWithHeuristic()
        }
        
        isLoading = false
    }
    
    // MARK: - Generación con Apple Intelligence
    
    private func generateWithAI() async {
        guard let session else {
            await generateWithHeuristic()
            return
        }
        
        let context = buildContext()
        let prompt = """
        Eres un asistente empático de salud mental preventiva.
        Basándote en estas respuestas recientes del usuario, genera nuevas preguntas en español:
        
        \(context)
        
        Responde ÚNICAMENTE con JSON, sin texto adicional:
        {
          "multipleChoiceQuestion": "<pregunta>",
          "options": ["<op1>", "<op2>", "<op3>", "<op4>"],
          "openQuestion": "<pregunta abierta empática>"
        }
        Las opciones van de mejor (índice 0) a peor estado (índice 3).
        """
        
        do {
            let response = try await session.respond(to: prompt)
            if !parseAndApply(json: response.content) {
                // Si el JSON falla, caer al heurístico
                await generateWithHeuristic()
            }
        } catch {
            await generateWithHeuristic()
        }
    }
    
    // MARK: - Generación heurística (fallback)
    
    private func generateWithHeuristic() async {
        // Simula un pequeño delay para UX coherente
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        let nextIndex = store.entries.count  // ya incluye la que acabamos de guardar
        let pair = selectAdaptivePair(nextIndex: nextIndex)
        
        applyPair(pair)
        usingAI = false
    }
    
    /// Elige el siguiente par considerando las respuestas recientes.
    /// Si el riesgo es alto, prioriza preguntas sobre sueño y relaciones.
    /// Si es bajo, rota normalmente.
    private func selectAdaptivePair(nextIndex: Int) -> QuestionBank.QuestionPair {
        let risk = store.riskLevel
        
        switch risk {
        case .alto:
            // Priorizar índices 2 (sueño) y 5 (relaciones) que son más reveladores
            let highRiskIndices = [2, 5, 1, 6]
            let candidate = highRiskIndices.first {
                // No repetir la misma pregunta que se acaba de responder
                QuestionBank.pairs[$0].multipleChoiceQuestion != multipleChoiceQuestion
            } ?? nextIndex % QuestionBank.pairs.count
            return QuestionBank.pairs[candidate]
            
        case .moderado:
            // Rotar entre motivación (3), concentración (4) y autocuidado (6)
            let moderateIndices = [3, 4, 6, 0]
            let candidate = moderateIndices.first {
                QuestionBank.pairs[$0].multipleChoiceQuestion != multipleChoiceQuestion
            } ?? nextIndex % QuestionBank.pairs.count
            return QuestionBank.pairs[candidate]
            
        default:
            // Rotación normal determinista
            return QuestionBank.pair(forEntry: nextIndex)
        }
    }
    
    // MARK: - Helpers
    
    private func buildContext() -> String {
        store.entries.suffix(5).map {
            "• \($0.multipleChoiceQuestion): \($0.multipleChoiceAnswer). \($0.openQuestion): \($0.openAnswer)"
        }.joined(separator: "\n")
    }
    
    @discardableResult
    private func parseAndApply(json: String) -> Bool {
        guard let data = json.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let mcq = obj["multipleChoiceQuestion"] as? String,
              let opts = obj["options"] as? [String],
              let oq = obj["openQuestion"] as? String,
              opts.count == 4
        else { return false }
        
        multipleChoiceQuestion = mcq
        options = opts
        openQuestion = oq
        // Las preguntas de AI no tienen pesos explícitos; usamos posición como proxy
        currentRiskWeights = [0, 0, 2, 3]
        resetAnswers()
        return true
    }
    
    private func applyPair(_ pair: QuestionBank.QuestionPair) {
        multipleChoiceQuestion = pair.multipleChoiceQuestion
        options = pair.options
        openQuestion = pair.openQuestion
        currentRiskWeights = pair.riskWeights
        resetAnswers()
    }
    
    private func resetAnswers() {
        selectedOption = ""
        selectedOptionIndex = -1
        openAnswer = ""
        isSaved = false
    }
}

// MARK: - Extensión segura de Array

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
