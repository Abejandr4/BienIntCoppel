import Foundation
import FoundationModels
internal import Combine

// MARK: - Banco de preguntas predeterminadas

struct QuestionBank {
    
    struct QuestionPair {
        let multipleChoiceQuestion: String
        let options: [String]
        let openQuestion: String
        // Pesos de riesgo por índice de opción (0 = mejor, 3 = peor)
        let riskWeights: [Int]
    }
    
    // Rotación semanal de 7 pares — cubren fatiga, humor, sueño, motivación,
    // relaciones, concentración y autocuidado
    static let pairs: [QuestionPair] = [
        QuestionPair(
            multipleChoiceQuestion: "¿Cómo describirías tu nivel de energía hoy?",
            options: ["Con mucha energía", "Normal, puedo con el día",
                      "Algo cansado/a", "Sin energía, agotado/a"],
            openQuestion: "¿Hubo algo esta semana que te quitara energía de forma especial?",
            riskWeights: [0, 0, 1, 3]
        ),
        QuestionPair(
            multipleChoiceQuestion: "¿Cómo ha estado tu estado de ánimo en los últimos días?",
            options: ["Muy bien, contento/a", "Estable, sin grandes altibajos",
                      "Irritable o con bajones", "Triste o vacío/a la mayor parte del tiempo"],
            openQuestion: "¿Hay algo que últimamente te cueste trabajo disfrutar?",
            riskWeights: [0, 0, 2, 3]
        ),
        QuestionPair(
            multipleChoiceQuestion: "¿Qué tan bien has dormido esta semana?",
            options: ["Muy bien, me siento descansado/a", "Aceptable",
                      "Mal, me desvelo o me levanto cansado/a", "Casi no he podido dormir"],
            openQuestion: "¿Qué sueles pensar justo antes de dormir?",
            riskWeights: [0, 1, 2, 3]
        ),
        QuestionPair(
            multipleChoiceQuestion: "¿Cuántas ganas tienes de hacer cosas que antes te gustaban?",
            options: ["Muchas ganas, me entusiasma", "Las mismas de siempre",
                      "Menos que antes, pero algo", "Casi ninguna, todo me da igual"],
            openQuestion: "¿Hay alguna actividad o persona que todavía te levante el ánimo?",
            riskWeights: [0, 0, 2, 3]
        ),
        QuestionPair(
            multipleChoiceQuestion: "¿Cómo está tu concentración en el trabajo o estudios?",
            options: ["Enfocado/a sin problema", "Distraído/a a veces pero funciono",
                      "Me cuesta mucho concentrarme", "No puedo terminar nada, me bloqueo"],
            openQuestion: "¿Sientes que el trabajo o los estudios te pesan más que antes?",
            riskWeights: [0, 1, 2, 3]
        ),
        QuestionPair(
            multipleChoiceQuestion: "¿Cómo te has sentido en tus relaciones cercanas esta semana?",
            options: ["Conectado/a y apoyado/a", "Normal, sin novedades",
                      "Un poco aislado/a o incomprendido/a", "Solo/a aunque esté rodeado/a de gente"],
            openQuestion: "¿Hay algo que te cueste trabajo contarle a alguien de confianza?",
            riskWeights: [0, 0, 2, 3]
        ),
        QuestionPair(
            multipleChoiceQuestion: "¿Has podido cuidarte esta semana (comer, moverte, descansar)?",
            options: ["Sí, me cuidé bien", "Más o menos, lo básico",
                      "Poco, lo dejé de lado", "Casi nada, me descuidé bastante"],
            openQuestion: "¿Qué es lo primero que sueles sacrificar cuando estás bajo presión?",
            riskWeights: [0, 0, 1, 3]
        )
    ]
    
    /// Devuelve el par correspondiente al día de uso (módulo del total)
    /// para que la rotación sea determinista y no repetitiva.
    static func pair(forEntry index: Int) -> QuestionPair {
        pairs[index % pairs.count]
    }
}

// MARK: - Modelos de datos

struct QuestionnaireEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let multipleChoiceQuestion: String
    let multipleChoiceAnswer: String
    let multipleChoiceRiskWeight: Int   // ← nuevo
    let openQuestion: String
    let openAnswer: String
}

// MARK: - Evaluación de riesgo (heurística mejorada)

struct RiskEvaluation {
    
    static func evaluate(entries: [QuestionnaireEntry]) -> RiskLevel {
        guard entries.count >= 3 else { return .sinDatos }
        
        let recent = Array(entries.suffix(5))
        var score = 0
        
        // 1. Peso acumulado de opciones elegidas
        score += recent.map(\.multipleChoiceRiskWeight).reduce(0, +)
        
        // 2. Análisis de texto abierto
        let highRiskKeywords = [
            "agotado", "sin energía", "no puedo", "no quiero", "triste",
            "desmotivado", "no duermo", "ansioso", "llorar", "solo",
            "vacío", "nada", "bloqueado", "colapso", "hartado", "burnout",
            "rendirme", "no aguanto", "no sirvo", "para qué"
        ]
        for entry in recent {
            let text = entry.openAnswer.lowercased()
            let hits = highRiskKeywords.filter { text.contains($0) }.count
            score += min(hits * 2, 4) // máx 4 pts por entrada abierta
        }
        
        // 3. Tendencia: si los últimos 3 pesos van en aumento, penalizar
        if recent.count >= 3 {
            let last3 = recent.suffix(3).map(\.multipleChoiceRiskWeight)
            if last3[0] < last3[1], last3[1] < last3[2] {
                score += 3 // tendencia empeorada
            }
        }
        
        switch score {
        case 0...4:  return .bajo
        case 5...10: return .moderado
        default:     return .alto
        }
    }
}

enum RiskLevel {
    case sinDatos, bajo, moderado, alto
    
    var shouldShowAlert: Bool { self == .alto || self == .moderado }
    
    var mensaje: String {
        switch self {
        case .sinDatos:  return ""
        case .bajo:      return "Todo apunta bien. Sigue cuidándote."
        case .moderado:  return "Detectamos señales de estrés sostenido. Considera hablar con alguien."
        case .alto:      return "Tus respuestas muestran un nivel de agotamiento importante. Hablar con un profesional puede ayudarte mucho."
        }
    }
}

// MARK: - Persistencia

class QuestionnaireStore: ObservableObject {
    @Published var entries: [QuestionnaireEntry] = []
    
    private let key = "questionnaire_entries_v2"
    
    init() { load() }
    
    func save(entry: QuestionnaireEntry) {
        entries.append(entry)
        persist()
    }
    
    private func persist() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([QuestionnaireEntry].self, from: data)
        else { return }
        entries = decoded
    }
    
    var riskLevel: RiskLevel { RiskEvaluation.evaluate(entries: entries) }
    
    /// Índice para el banco de preguntas (siguiente par a mostrar)
    var nextQuestionIndex: Int { entries.count }
}
