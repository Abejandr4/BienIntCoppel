import SwiftUI

// MARK: - RecommendedExerciseView


struct RecommendedExerciseView: View {
    
    // Score que ya genera tu QuestionnaireViewModel
    var scoresCuestionario: Int = 50
    
    @ObservedObject private var tracker = UserInteractionTracker.shared
    @State private var perfil: PerfilUsuario = .inactivo
    @State private var ejercicioRecomendado: MentalExercise? = nil
    @State private var mostrarDetalle = false
    
    // Ejercicios del JSON
    private let ejercicios = ExercisesData.all
    
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
                        let categoria = categoriaDelEjercicio(ejercicio)
                        tracker.registrarClic(categoria: categoria)
                        mostrarDetalle = true
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
                .sheet(isPresented: $mostrarDetalle) {
                    if let ejercicio = ejercicioRecomendado {
                        ExerciseDetailSheet(exercise: ejercicio)
                    }
                }
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
