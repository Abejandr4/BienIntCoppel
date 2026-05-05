import Foundation

// MARK: - Tipos de pregunta

enum QuestionType: String, Codable, CaseIterable {
    case openText           // Respuesta de texto libre
    case multipleChoiceText // Opciones de texto largas
    case multipleChoiceEmoji // Opciones con emoji y/o número
}

enum BurnoutDimension: String, Codable, CaseIterable {
    case cargaLaboral       // 1. Evento / Carga laboral
    case agotamientoEmocional   // 2. Agotamiento emocional
    case despersonalizacion     // 3. Despersonalización
    case realizacionPersonal    // 4. Realización personal
    case indicadoresFisicos     // 5. Indicadores psicosomáticos
}

// MARK: - Modelo de pregunta unificado

struct BurnoutQuestion: Identifiable {
    let id: UUID
    let dimension: BurnoutDimension
    let type: QuestionType
    let text: String
    let options: [String]?      // nil para openText
    let riskWeights: [Int]?     // nil para openText; índice = peso de riesgo
    
    init(
        dimension: BurnoutDimension,
        type: QuestionType,
        text: String,
        options: [String]? = nil,
        riskWeights: [Int]? = nil
    ) {
        self.id = UUID()
        self.dimension = dimension
        self.type = type
        self.text = text
        self.options = options
        self.riskWeights = riskWeights
    }
}

// MARK: - Respuesta del usuario

struct QuestionResponse: Codable {
    let questionText: String
    let questionType: QuestionType
    let dimension: BurnoutDimension
    let textAnswer: String?         // para openText
    let selectedOption: String?     // para múltiple
    let riskWeight: Int             // 0–3
}

// MARK: - Entrada completa de una sesión

struct QuestionnaireEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let responses: [QuestionResponse]   // 1 o 2 respuestas por sesión
}

// MARK: - Banco de preguntas

struct QuestionBank {
    
    // ─────────────────────────────────────────────
    // 1. CARGA LABORAL
    // ─────────────────────────────────────────────
    
    static let cargaLaboral: [BurnoutQuestion] = [
        
        BurnoutQuestion(
            dimension: .cargaLaboral,
            type: .multipleChoiceEmoji,
            text: "¿Cuántas horas estuviste hoy de pie en el piso de ventas o frente a la ventanilla?",
            options: ["⏱️ Menos de 4 h", "⏱️ 4–6 h", "⏱️ 6–8 h", "⏱️ Más de 8 h"],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .cargaLaboral,
            type: .multipleChoiceEmoji,
            text: "¿Qué tan lejos sentiste que quedaron tus metas de colocación hoy?",
            options: ["🎯 Las superé", "🟡 Cerca, casi las alcanzo", "🔴 Bastante lejos", "💀 Ni cerca"],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .cargaLaboral,
            type: .multipleChoiceEmoji,
            text: "¿Cuántos clientes con reclamos o situaciones difíciles atendiste hoy?",
            options: ["0️⃣ Ninguno", "1️⃣–2️⃣ Uno o dos", "3️⃣–5️⃣ Tres a cinco", "6️⃣+ Seis o más"],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .cargaLaboral,
            type: .multipleChoiceText,
            text: "¿Sentiste que hoy tuviste control sobre cómo organizar tu trabajo?",
            options: [
                "Sí, pude organizarme con libertad",
                "Más o menos, con algunas interrupciones",
                "Poco, fui interrumpido constantemente por órdenes externas",
                "Nada, solo seguí instrucciones sin poder decidir nada"
            ],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .cargaLaboral,
            type: .openText,
            text: "¿Hubo alguna situación hoy en la tienda que sientas que se salió de control o que no pudiste manejar bien?"
        )
    ]
    
    // ─────────────────────────────────────────────
    // 2. AGOTAMIENTO EMOCIONAL
    // ─────────────────────────────────────────────
    
    static let agotamientoEmocional: [BurnoutQuestion] = [
        
        BurnoutQuestion(
            dimension: .agotamientoEmocional,
            type: .multipleChoiceEmoji,
            text: "¿Cómo llegaste hoy al ponerte el uniforme?",
            options: ["⚡ Con energía y ganas", "😐 Neutro, ni fu ni fa", "😩 Con pesadez", "😵 Sin querer ir"],
            riskWeights: [0, 0, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .agotamientoEmocional,
            type: .multipleChoiceText,
            text: "Al terminar tu turno, ¿cómo describes tu energía para el resto del día?",
            options: [
                "Tengo energía para mi familia, proyectos o descansar bien",
                "Estoy cansado/a pero puedo con lo básico en casa",
                "Llego agotado/a y solo quiero no hablar con nadie",
                "Siento un vacío emocional, como si no quedara nada de mí"
            ],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .agotamientoEmocional,
            type: .multipleChoiceEmoji,
            text: "¿Cómo fue tu descanso anoche?",
            options: ["😴 Dormí bien y me desconecté", "🙂 Regular, algo de insomnio", "😟 Me desperté pensando en el trabajo", "😰 Casi no dormí por la presión"],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .agotamientoEmocional,
            type: .openText,
            text: "¿Hay algo del trabajo en Coppel que últimamente no te puedas sacar de la cabeza cuando llegas a casa?"
        )
    ]
    
    // ─────────────────────────────────────────────
    // 3. DESPERSONALIZACIÓN
    // ─────────────────────────────────────────────
    
    static let despersonalizacion: [BurnoutQuestion] = [
        
        BurnoutQuestion(
            dimension: .despersonalizacion,
            type: .multipleChoiceText,
            text: "¿Cómo sentiste a los clientes hoy en general?",
            options: [
                "Como personas con necesidades reales que quería atender bien",
                "Normal, sin pensarlo mucho",
                "A veces como una carga, aunque traté de no demostrarlo",
                "Como un obstáculo para terminar mi turno"
            ],
            riskWeights: [0, 0, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .despersonalizacion,
            type: .multipleChoiceEmoji,
            text: "¿Sentiste ganas de responder de forma fría o cortante ante algún cliente hoy?",
            options: ["😊 No, para nada", "😐 Una o dos veces lo pensé", "😤 Varias veces tuve que contenerme", "😠 Sí, y no siempre lo pude evitar"],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .despersonalizacion,
            type: .multipleChoiceText,
            text: "¿Con qué frecuencia bromeas con compañeros sobre los clientes de forma despectiva para liberar tensión?",
            options: [
                "Nunca, prefiero no hablar así de los clientes",
                "Rara vez, solo cuando fue algo muy difícil",
                "Seguido, es como una válvula de escape",
                "Casi siempre, ya es parte de la rutina con mis compañeros"
            ],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .despersonalizacion,
            type: .openText,
            text: "¿Recuerdas algún momento de hoy donde sentiste que ya no te importaba cómo saliera la atención al cliente?"
        )
    ]
    
    // ─────────────────────────────────────────────
    // 4. REALIZACIÓN PERSONAL
    // ─────────────────────────────────────────────
    
    static let realizacionPersonal: [BurnoutQuestion] = [
        
        BurnoutQuestion(
            dimension: .realizacionPersonal,
            type: .multipleChoiceText,
            text: "¿Cómo te fuiste hoy al terminar tu turno?",
            options: [
                "Sintiéndome útil, creo que ayudé a alguien hoy",
                "Neutral, fue un día más",
                "Con la sensación de que mi trabajo no importó",
                "Pensando que este trabajo no tiene sentido para mí"
            ],
            riskWeights: [0, 0, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .realizacionPersonal,
            type: .multipleChoiceEmoji,
            text: "¿Recibiste algún reconocimiento de tu gerente o jefe de piso hoy?",
            options: ["🌟 Sí, me felicitaron", "👍 Un comentario positivo breve", "😶 Nada, ni bueno ni malo", "👎 Solo críticas o presión"],
            riskWeights: [0, 0, 1, 3]
        ),
        
        BurnoutQuestion(
            dimension: .realizacionPersonal,
            type: .multipleChoiceText,
            text: "¿Cómo ves tu futuro dentro de Coppel?",
            options: [
                "Me veo creciendo, hay posibilidades reales",
                "No lo he pensado mucho últimamente",
                "Siento que estoy estancado/a",
                "Siento que estoy en un callejón sin salida"
            ],
            riskWeights: [0, 0, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .realizacionPersonal,
            type: .openText,
            text: "¿Hubo algo hoy, por pequeño que sea, que te haya hecho sentir que tu trabajo valió la pena?"
        )
    ]
    
    // ─────────────────────────────────────────────
    // 5. INDICADORES PSICOSOMÁTICOS
    // ─────────────────────────────────────────────
    
    static let indicadoresFisicos: [BurnoutQuestion] = [
        
        BurnoutQuestion(
            dimension: .indicadoresFisicos,
            type: .multipleChoiceEmoji,
            text: "¿Presentaste alguno de estos síntomas hoy?",
            options: ["✅ Ninguno", "🔴 Dolor de espalda o cuello", "🔴 Dolor de cabeza tensional", "🔴 Problemas digestivos o náuseas"],
            riskWeights: [0, 2, 2, 2]
        ),
        
        BurnoutQuestion(
            dimension: .indicadoresFisicos,
            type: .multipleChoiceText,
            text: "¿Tuviste olvidos inusuales hoy en el trabajo?",
            options: [
                "No, todo fluyó con normalidad",
                "Uno o dos pequeños descuidos sin consecuencias",
                "Sí, olvidé procedimientos o datos que conozco bien",
                "Sí, varios olvidos que me generaron problemas o vergüenza"
            ],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .indicadoresFisicos,
            type: .multipleChoiceEmoji,
            text: "¿Con que cara te identificas más según tu nivel de tensión física (músculos, mandíbula, postura)?",
            options: ["😌", "🙂", "😬", "🤕"],
            riskWeights: [0, 1, 2, 3]
        ),
        
        BurnoutQuestion(
            dimension: .indicadoresFisicos,
            type: .openText,
            text: "¿Tu cuerpo te está mandando alguna señal de que algo no está bien? Puedes describir lo que sea, aunque parezca menor."
        )
    ]
    
    // MARK: - Acceso unificado
    
    static var all: [BurnoutQuestion] {
        cargaLaboral + agotamientoEmocional + despersonalizacion +
        realizacionPersonal + indicadoresFisicos
    }
    
    static func questions(for dimension: BurnoutDimension) -> [BurnoutQuestion] {
        switch dimension {
        case .cargaLaboral:         return cargaLaboral
        case .agotamientoEmocional: return agotamientoEmocional
        case .despersonalizacion:   return despersonalizacion
        case .realizacionPersonal:  return realizacionPersonal
        case .indicadoresFisicos:   return indicadoresFisicos
        }
    }
}
