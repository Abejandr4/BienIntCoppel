import SwiftUI

// MARK: - RecommendedExerciseView
// Agrégala dentro de MentalWellnessView, justo ANTES de MentalExercisesView().
// Ejemplo:
//   RecommendedExerciseView(scoresCuestionario: 50)
//   MentalExercisesView()

struct RecommendedExerciseView: View {
    
    // Pasa aquí el score que ya genera tu QuestionnaireViewModel
    var scoresCuestionario: Int = 50
    
    @ObservedObject private var tracker = UserInteractionTracker.shared
    @State private var perfil: PerfilUsuario = .inactivo
    @State private var ejercicioRecomendado: MentalExercise? = nil
    
    // Los ejercicios del JSON — reemplaza esto con tu fuente real cuando la conectes
    private let ejercicios: [MentalExercise] = [
        MentalExercise(title: "Respiración Diafragmática", benefit: "Calma inmediata y reducción de tensión.", icon: "wind", colors: [Color(red:0.92,green:0.96,blue:1.0), Color.white], iconColor: .blue, duration: "5 min", description: "Inhalar profundamente permitiendo que el abdomen se expanda."),
        MentalExercise(title: "Técnica 4-7-8", benefit: "Sedación del sistema nervioso.", icon: "lungs.fill", colors: [Color(red:0.92,green:0.96,blue:1.0), Color.white], iconColor: .blue, duration: "2 min", description: "Inhalar 4s, retener 7s, exhalar 8s."),
        MentalExercise(title: "Respiración Cuadrada", benefit: "Estabilización emocional durante crisis.", icon: "square", colors: [Color(red:0.92,green:0.96,blue:1.0), Color.white], iconColor: .blue, duration: "4 min", description: "Inhalar, retener, exhalar y mantener 4s cada fase."),
        MentalExercise(title: "Grounding 5-4-3-2-1", benefit: "Interrupción de ataques de pánico.", icon: "hand.point.up.left.fill", colors: [Color(red:0.90,green:0.98,blue:0.94), Color.white], iconColor: .green, duration: "3 min", description: "5 cosas que ves, 4 que tocas, 3 que oyes, 2 que hueles, 1 que saboreas."),
        MentalExercise(title: "Escaneo Corporal Exprés", benefit: "Identificación de somatizaciones por estrés.", icon: "figure.walk.motion", colors: [Color(red:0.90,green:0.98,blue:0.94), Color.white], iconColor: .green, duration: "5 min", description: "Recorrer mentalmente el cuerpo de pies a cabeza."),
        MentalExercise(title: "Observación de Objeto Neutral", benefit: "Recuperación de la atención ejecutiva.", icon: "eye.fill", colors: [Color(red:0.90,green:0.98,blue:0.94), Color.white], iconColor: .green, duration: "2 min", description: "Mirar fijamente un objeto y notar sus detalles."),
        MentalExercise(title: "Relajación Muscular Progresiva", benefit: "Liberación de contracturas por estrés.", icon: "figure.flexibility", colors: [Color(red:0.95,green:0.93,blue:1.0), Color.white], iconColor: .purple, duration: "10 min", description: "Tensar un grupo muscular 5s y relajar 10s."),
        MentalExercise(title: "Sacudida Somática", benefit: "Liberación de adrenalina acumulada.", icon: "waveform", colors: [Color(red:0.95,green:0.93,blue:1.0), Color.white], iconColor: .purple, duration: "2 min", description: "Sacudir manos, brazos y piernas vigorosamente."),
        MentalExercise(title: "Diario de Vaciado", benefit: "Reducción de la carga cognitiva.", icon: "square.and.pencil", colors: [Color(red:1.0,green:0.95,blue:0.90), Color.white], iconColor: .orange, duration: "10 min", description: "Escribir sin filtro todo lo que genera estrés."),
        MentalExercise(title: "Diario de Gratitud", benefit: "Reentrenamiento del sesgo de negatividad.", icon: "heart.text.square.fill", colors: [Color(red:1.0,green:0.95,blue:0.90), Color.white], iconColor: .orange, duration: "3 min", description: "Anotar 3 cosas específicas por las que estás agradecido."),
        MentalExercise(title: "Plan Micro-conductual", benefit: "Reducción de la parálisis por análisis.", icon: "checklist", colors: [Color(red:1.0,green:0.95,blue:0.90), Color.white], iconColor: .orange, duration: "2 min", description: "Escribir una sola acción pequeña para la próxima hora.")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: Header
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                    .font(.system(size: 14))
                Text("Recomendado para ti")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                Text(perfil.rawValue.capitalized)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(badgeColor(perfil: perfil))
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
            
            // MARK: Descripción del perfil
            Text(perfil.descripcion)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            // MARK: Tarjeta del ejercicio recomendado
            if let ejercicio = ejercicioRecomendado {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(ejercicio.iconColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: ejercicio.icon)
                            .font(.system(size: 22))
                            .foregroundColor(ejercicio.iconColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ejercicio.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        Text(ejercicio.benefit)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        Text(ejercicio.duration)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Registra el clic al iniciar el ejercicio
                        let categoria = categoriaDelEjercicio(ejercicio)
                        tracker.registrarClic(categoria: categoria)
                        // Aquí puedes navegar a la pantalla del ejercicio
                    }) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(ejercicio.iconColor)
                            .clipShape(Circle())
                    }
                }
                .padding(16)
                .background(
                    LinearGradient(
                        colors: ejercicio.colors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
        .padding(.top, 16)
        .onAppear { actualizarRecomendacion() }
        .onChange(of: tracker.clicksRespiracion) { _ in actualizarRecomendacion() }
        .onChange(of: tracker.clicksMindfulness) { _ in actualizarRecomendacion() }
        .onChange(of: tracker.clicksSomatico)    { _ in actualizarRecomendacion() }
        .onChange(of: tracker.clicksEscritura)   { _ in actualizarRecomendacion() }
    }
    
    // MARK: - Helpers
    
    private func actualizarRecomendacion() {
        let engine = ExerciseRecommendationEngine.shared
        perfil = engine.predecirPerfil(scoresCuestionario: scoresCuestionario)
        ejercicioRecomendado = engine.ejercicioRecomendado(para: perfil, ejercicios: ejercicios)
    }
    
    private func categoriaDelEjercicio(_ ejercicio: MentalExercise) -> String {
        switch ejercicio.iconColor {
        case .blue:   return "respiracion"
        case .green:  return "mindfulness"
        case .purple: return "somatico"
        case .orange: return "escritura"
        default:      return "mindfulness"
        }
    }
    
    private func badgeColor(perfil: PerfilUsuario) -> Color {
        switch perfil {
        case .ansioso:  return .blue
        case .estable:  return .green
        case .inactivo: return .orange
        case .avanzado: return .purple
        }
    }
}

// MARK: - Preview
struct RecommendedExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(white: 0.97).edgesIgnoringSafeArea(.all)
            RecommendedExerciseView(scoresCuestionario: 40)
        }
    }
}
