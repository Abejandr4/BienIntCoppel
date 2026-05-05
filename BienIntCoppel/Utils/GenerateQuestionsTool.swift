    import Foundation
    import FoundationModels

    // MARK: - Parámetros de entrada y salida del Tool

    struct GenerateQuestionsInput: Codable {
        let previousAnswers: [String]   // respuestas anteriores del usuario
        let riskKeywords: [String]      // palabras clave detectadas
    }

    @Generable
    struct GeneratedQuestions {
        @Guide(description: "Pregunta de opción múltiple sobre estado emocional o físico, en español.")
        var multipleChoiceQuestion: String
        
        @Guide(description: "Exactamente 4 opciones de respuesta, de menor a mayor intensidad negativa.")
        var options: [String]
        
        @Guide(description: "Pregunta abierta y empática sobre cómo se siente el usuario hoy, en español.")
        var openQuestion: String
    }

    // MARK: - Tool

struct GenerateQuestionsTool: Tool {
    typealias Output = String
    
        let name = "GenerateQuestionsTool"
        let description = "Genera preguntas personalizadas de salud mental basadas en respuestas anteriores del usuario para detectar señales de burnout o crisis emocional."
        
        @Generable
        struct Arguments {
            @Guide(description: "Resumen breve de las respuestas previas del usuario.")
            var contextoAnterior: String
        }
        
        func call(arguments: Arguments) async throws -> String {
            // Este tool sirve como contexto para el agente;
            // la generación real ocurre en QuestionnaireViewModel
            return "Contexto recibido: \(arguments.contextoAnterior)"
        }
    }
