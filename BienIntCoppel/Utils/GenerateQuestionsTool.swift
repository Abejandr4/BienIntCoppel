import Foundation
import FoundationModels

// MARK: - Modelo de pregunta generada por AI

@Generable
struct AIGeneratedQuestion {
    @Guide(description: """
        Dimensión de burnout. Valores válidos exactos:
        cargaLaboral, agotamientoEmocional, despersonalizacion,
        realizacionPersonal, indicadoresFisicos
        """)
    var dimension: String

    @Guide(description: """
        Tipo de pregunta. Valores válidos exactos:
        openText, multipleChoiceText, multipleChoiceEmoji, emojiOnly
        """)
    var type: String

    @Guide(description: """
        Texto de la pregunta en español, empático,
        contextualizado en el trabajo en Coppel.
        """)
    var text: String

    @Guide(description: """
        Opciones de respuesta. Reglas por tipo:
        - openText: dejar vacío []
        - multipleChoiceText: 4 frases descriptivas, de mejor (índice 0) a peor estado (índice 3)
        - multipleChoiceEmoji: 4 opciones, cada una comienza con un emoji seguido de texto
        - emojiOnly: 5 emojis solos, de mejor (índice 0) a peor estado (índice 4)
        """)
    var options: [String]
}

@Generable
struct AIGeneratedPair {
    @Guide(description: "Primera pregunta del cuestionario.")
    var first: AIGeneratedQuestion

    @Guide(description: "Segunda pregunta, de dimensión distinta a la primera.")
    var second: AIGeneratedQuestion
}

// MARK: - Tool
struct GenerateQuestionsTool: Tool {
    func call(arguments: Arguments) async throws -> String {
        //no se necesita hacer nada aquí porque la herramienta genera las preguntas abajo
    }
    
    typealias Output = String
    
    let name = "generateQuestions"
    let description = """
        Genera el siguiente par de preguntas personalizadas de salud mental
        para un empleado de Coppel, basándose en su historial de respuestas.
        Siempre genera exactamente 2 preguntas de dimensiones distintas.
        """

    @Generable
    struct Arguments {
        @Guide(description: """
            Resumen del historial reciente del usuario: dimensiones con mayor
            riesgo, tipo de pregunta que más responde, y patrones detectados.
            """)
        var contexto: String

        @Guide(description: """
            Tipo de pregunta preferido por el usuario según su historial:
            openText, multipleChoiceText, multipleChoiceEmoji, o emojiOnly.
            """)
        var tipoPreferido: String

        @Guide(description: """
            Dimensiones que NO deben usarse porque ya se preguntaron
            recientemente. Lista separada por comas.
            """)
        var dimensionesRecientes: String
    }

}
