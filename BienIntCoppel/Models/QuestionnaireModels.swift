import Foundation
import FoundationModels
internal import Combine

class QuestionnaireStore: ObservableObject {
    
    @Published var entries: [QuestionnaireEntry] = []
    
    // Conteo de cuántas veces el usuario respondió cada tipo
    @Published var typeEngagement: [QuestionType: Int] = [
        .openText: 0,
        .multipleChoiceText: 0,
        .multipleChoiceEmoji: 0
    ]
    
    private let entriesKey   = "burnout_entries_v3"
    private let engagementKey = "burnout_type_engagement"
    
    init() { load() }
    
    // MARK: - Guardar sesión
    
    func save(entry: QuestionnaireEntry) {
        entries.append(entry)
        updateEngagement(from: entry)
        persist()
    }
    
    private func updateEngagement(from entry: QuestionnaireEntry) {
        for response in entry.responses {
            // Solo cuenta como "respondida" si tiene contenido real
            let hasContent: Bool
            switch response.questionType {
            case .openText:
                hasContent = !(response.textAnswer?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
            default:
                hasContent = response.selectedOption != nil
            }
            if hasContent {
                typeEngagement[response.questionType, default: 0] += 1
            }
        }
        persistEngagement()
    }
    
    // MARK: - Probabilidad de selección por tipo
    
    /// Devuelve los pesos de selección para cada tipo.
    /// Garantiza que ningún tipo baje de un piso del 15 %
    /// para no abandonar ninguna dimensión.
    func selectionWeights() -> [QuestionType: Double] {
        let total = typeEngagement.values.reduce(0, +)
        guard total > 0 else {
            // Sin historial: distribución uniforme
            return [.openText: 1, .multipleChoiceText: 1, .multipleChoiceEmoji: 1]
        }
        
        var weights: [QuestionType: Double] = [:]
        let floor = 0.15   // mínimo 15 % para cada tipo
        
        for type in QuestionType.allCases {
            let raw = Double(typeEngagement[type, default: 0]) / Double(total)
            weights[type] = max(raw, floor)
        }
        
        // Renormalizar para que sumen 1
        let sum = weights.values.reduce(0, +)
        for type in QuestionType.allCases {
            weights[type] = (weights[type] ?? floor) / sum
        }
        
        return weights
    }
    
    /// Elige un tipo al azar respetando los pesos calculados
    func pickWeightedType(excluding: QuestionType? = nil) -> QuestionType {
        var weights = selectionWeights()
        if let excluded = excluding {
            weights[excluded] = 0
            let sum = weights.values.reduce(0, +)
            guard sum > 0 else { return excluded == .openText ? .multipleChoiceText : .openText }
            for type in QuestionType.allCases { weights[type] = (weights[type] ?? 0) / sum }
        }
        
        let r = Double.random(in: 0..<1)
        var cumulative = 0.0
        for type in QuestionType.allCases {
            cumulative += weights[type] ?? 0
            if r < cumulative { return type }
        }
        return .multipleChoiceEmoji
    }
    
    // MARK: - Evaluación de riesgo
    
    var riskLevel: RiskLevel { RiskEvaluation.evaluate(entries: entries) }
    
    var sessionCount: Int { entries.count }
    
    // MARK: - Persistencia
    
    private func persist() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: entriesKey)
        }
    }
    
    private func persistEngagement() {
        let raw = typeEngagement.reduce(into: [String: Int]()) { $0[$1.key.rawValue] = $1.value }
        UserDefaults.standard.set(raw, forKey: engagementKey)
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([QuestionnaireEntry].self, from: data) {
            entries = decoded
        }
        if let raw = UserDefaults.standard.dictionary(forKey: engagementKey) as? [String: Int] {
            typeEngagement = raw.reduce(into: [:]) {
                if let type = QuestionType(rawValue: $1.key) { $0[type] = $1.value }
            }
        }
    }
}


// MARK: - Evaluación de riesgo

struct RiskEvaluation {
    
    static func evaluate(entries: [QuestionnaireEntry]) -> RiskLevel {
        guard entries.count >= 3 else { return .sinDatos }
        
        let recent = Array(entries.suffix(5))
        var score = 0
        
        // 1. Peso acumulado de todas las respuestas de opción múltiple
        let allResponses = recent.flatMap(\.responses)
        score += allResponses
            .filter { $0.questionType != .openText }
            .map(\.riskWeight)
            .reduce(0, +)
        
        // 2. Análisis de texto abierto
        let highRiskKeywords = [
            "agotado", "sin energía", "no puedo", "no quiero", "triste",
            "desmotivado", "no duermo", "ansioso", "llorar", "solo",
            "vacío", "nada", "bloqueado", "colapso", "hartado", "burnout",
            "rendirme", "no aguanto", "no sirvo", "para qué", "no vale",
            "harto", "ya no quiero", "no me importa", "inútil"
        ]
        let openTexts = allResponses
            .filter { $0.questionType == .openText }
            .compactMap(\.textAnswer)
        
        for text in openTexts {
            let lower = text.lowercased()
            let hits = highRiskKeywords.filter { lower.contains($0) }.count
            score += min(hits * 2, 4)
        }
        
        // 3. Tendencia por dimensión: penalizar si una dimensión
        //    muestra pesos crecientes en las últimas 3 sesiones
        score += trendPenalty(entries: recent)
        
        // 4. Bonus por dimensiones críticas con peso alto
        //    Despersonalización y agotamiento emocional pesan más
        let criticalScore = allResponses
            .filter {
                ($0.dimension == .despersonalizacion ||
                 $0.dimension == .agotamientoEmocional) &&
                $0.riskWeight >= 2
            }.count
        score += criticalScore * 2
        
        switch score {
        case 0...4:  return .bajo
        case 5...12: return .moderado
        default:     return .alto
        }
    }
    
    // Calcula si alguna dimensión muestra tendencia de empeoramiento
    // a través de las últimas 3 entradas
    private static func trendPenalty(entries: [QuestionnaireEntry]) -> Int {
        guard entries.count >= 3 else { return 0 }
        let last3 = Array(entries.suffix(3))
        var penalty = 0
        
        for dimension in BurnoutDimension.allCases {
            // Peso promedio de esa dimensión por sesión
            let weights: [Double] = last3.map { entry in
                let relevant = entry.responses.filter { $0.dimension == dimension }
                guard !relevant.isEmpty else { return 0 }
                return Double(relevant.map(\.riskWeight).reduce(0, +)) / Double(relevant.count)
            }
            // Solo penalizar si hay datos en las 3 sesiones y van en aumento
            let hasData = weights.filter { $0 > 0 }.count >= 2
            if hasData, weights[0] < weights[1], weights[1] < weights[2] {
                penalty += 3
            }
        }
        return penalty
    }
}

// MARK: - RiskLevel

enum RiskLevel {
    case sinDatos, bajo, moderado, alto
    
    var shouldShowAlert: Bool { self == .alto || self == .moderado }
    
    var mensaje: String {
        switch self {
        case .sinDatos:
            return ""
        case .bajo:
            return "Todo apunta bien. Sigue cuidándote."
        case .moderado:
            return "Detectamos señales de estrés sostenido en tu jornada. Considera hablar con alguien de confianza."
        case .alto:
            return "Tus respuestas muestran señales importantes de agotamiento. Hablar con un profesional puede ayudarte mucho."
        }
    }
}
