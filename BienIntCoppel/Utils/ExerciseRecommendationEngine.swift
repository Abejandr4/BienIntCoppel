import Foundation
import CoreML

// MARK: - Perfil de usuario
enum PerfilUsuario: String {
    case ansioso  = "ansioso"
    case estable  = "estable"
    case inactivo = "inactivo"
    case avanzado = "avanzado"
    
    var titulo: String {
        switch self {
        case .ansioso:  return "Momento de calma"
        case .estable:  return "Explora algo nuevo"
        case .inactivo: return "Empieza con poco"
        case .avanzado: return "Siguiente reto"
        }
    }
    
    var descripcion: String {
        switch self {
        case .ansioso:  return "Basado en tus hábitos, aquí hay algo que ya te funciona."
        case .estable:  return "¡Vas muy bien! Te recomendamos explorar una categoría diferente."
        case .inactivo: return "Un ejercicio corto para retomar el ritmo."
        case .avanzado: return "Ya dominas varias categorías, aquí hay un nuevo desafío."
        }
    }
    
    var iconColor: String {
        switch self {
        case .ansioso:  return "blue"
        case .estable:  return "green"
        case .inactivo: return "orange"
        case .avanzado: return "purple"
        }
    }
}

// MARK: - ExerciseRecommendationEngine
class ExerciseRecommendationEngine {
    
    static let shared = ExerciseRecommendationEngine()
    private var model: MentalWellnessClassifier?
    
    private init() {
        model = try? MentalWellnessClassifier(configuration: MLModelConfiguration())
    }
    
    // MARK: - Predecir perfil
    func predecirPerfil(scoresCuestionario: Int = 50) -> PerfilUsuario {
        let tracker = UserInteractionTracker.shared
        
        guard let model = model,
              let input = try? MentalWellnessClassifierInput(
                clicks_respiracion: Int64(tracker.clicksRespiracion),
                clicks_mindfulness: Int64(tracker.clicksMindfulness),
                clicks_somatico:    Int64(tracker.clicksSomatico),
                clicks_escritura:   Int64(tracker.clicksEscritura),
                dias_activos:       Int64(tracker.diasActivos),
                score_cuestionario: Int64(scoresCuestionario)
              ),
              let output = try? model.prediction(input: input)
        else {
            return perfilPorReglas(scoresCuestionario: scoresCuestionario)
        }
        
        return PerfilUsuario(rawValue: output.perfil) ?? .inactivo
    }
    
    // MARK: - Recomendar ejercicio según perfil
    func ejercicioRecomendado(para perfil: PerfilUsuario, ejercicios: [MentalExercise]) -> MentalExercise? {
        let tracker = UserInteractionTracker.shared
        
        switch perfil {
            
        case .ansioso:
                // Refuerza la categoría más usada
                let categoria = categoriaConMasClicks(tracker: tracker)
                return ejerciciosPorCategoria(categoria).first

        case .estable:
                // Promueve la categoría menos usada, el ejercicio más corto de esa categoría
                let categoria = categoriaConMenosClicks(tracker: tracker)
                return ejerciciosPorCategoria(categoria)
                    .min(by: { duracionEnMinutos($0.duration) < duracionEnMinutos($1.duration) })

        case .inactivo:
                // El ejercicio más corto de todo el catálogo
                return ExercisesData.all
                    .min(by: { duracionEnMinutos($0.duration) < duracionEnMinutos($1.duration) })

        case .avanzado:
                // Categoría menos visitada, ejercicio aleatorio
                let categoria = categoriaConMenosClicks(tracker: tracker)
                return ejerciciosPorCategoria(categoria).randomElement()
        }
    }
    
    // MARK: - Helper por categoría usando ExercisesData
    private func ejerciciosPorCategoria(_ categoria: String) -> [MentalExercise] {
        switch categoria {
        case "respiracion": return ExercisesData.respiracion
        case "mindfulness": return ExercisesData.mindfulness
        case "somatico":    return ExercisesData.somatico
        case "escritura":   return ExercisesData.escritura
        default:            return ExercisesData.all
        }
    }
    
    
    // MARK: - Helpers privados
    
    private func categoriaConMasClicks(tracker: UserInteractionTracker) -> String {
        let categorias: [(String, Int)] = [
            ("respiracion", tracker.clicksRespiracion),
            ("mindfulness", tracker.clicksMindfulness),
            ("somatico",    tracker.clicksSomatico),
            ("escritura",   tracker.clicksEscritura)
        ]
        return categorias.max(by: { $0.1 < $1.1 })?.0 ?? "respiracion"
    }
    
    private func categoriaConMenosClicks(tracker: UserInteractionTracker) -> String {
        let categorias: [(String, Int)] = [
            ("respiracion", tracker.clicksRespiracion),
            ("mindfulness", tracker.clicksMindfulness),
            ("somatico",    tracker.clicksSomatico),
            ("escritura",   tracker.clicksEscritura)
        ]
        return categorias.min(by: { $0.1 < $1.1 })?.0 ?? "escritura"
    }
    
    private func duracionEnMinutos(_ duracion: String) -> Int {
        // Extrae el primer número de strings como "5 min", "2-3 min", "10 min"
        let numeros = duracion.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return Int(numeros.first(where: { !$0.isEmpty }) ?? "99") ?? 99
    }
    
    // MARK: - Fallback por reglas (si CoreML falla)
    private func perfilPorReglas(scoresCuestionario: Int) -> PerfilUsuario {
        let tracker = UserInteractionTracker.shared
        let totalClicks = tracker.clicksRespiracion + tracker.clicksMindfulness +
                          tracker.clicksSomatico + tracker.clicksEscritura
        
        if totalClicks < 3 { return .inactivo }
        if scoresCuestionario > 65 { return .ansioso }
        if tracker.diasActivos >= 18 && totalClicks > 40 { return .avanzado }
        return .estable
    }
}
