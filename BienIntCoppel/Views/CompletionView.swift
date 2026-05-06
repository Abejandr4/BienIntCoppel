import SwiftUI

struct CompletionView: View {
    
    @EnvironmentObject var appState: AppState
    @ScaledMetric private var iconSize: CGFloat = 64
    
    // Elegir un ejercicio aleatorio una sola vez al aparecer la vista
    @State private var randomExercise: MentalExercise = ExercisesData.all.randomElement()!
    
    private var headline: String {
        switch appState.alertLevel {
        case .normal, .watch:   return "¡Gracias por compartir cómo te sientes!"
        case .warning:          return "Gracias por ser honesto/a contigo mismo/a."
        case .critical:         return "Nos importa cómo estás."
        }
    }
    
    private var subtitle: String {
        switch appState.alertLevel {
        case .normal, .watch:
            return "Tus respuestas nos ayudan a entenderte mejor cada día."
        case .warning:
            return "Hemos notado que has tenido días difíciles. No tienes que cargarlo solo/a."
        case .critical:
            return "Tus respuestas muestran señales importantes. Hablar con alguien puede hacer una gran diferencia."
        }
    }
    
    private var iconName: String {
        switch appState.alertLevel {
        case .normal, .watch:   return "checkmark.seal.fill"
        case .warning:          return "heart.fill"
        case .critical:         return "heart.text.clipboard.fill"
        }
    }
    
    private var iconColor: Color {
        switch appState.alertLevel {
        case .normal, .watch:   return Color(red: 0.1,  green: 0.5,  blue: 0.15)
        case .warning:          return Color(red: 0.75, green: 0.35, blue: 0.0)
        case .critical:         return Color(red: 0.75, green: 0.1,  blue: 0.2)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.97, blue: 0.93),
                         Color(red: 0.96, green: 0.99, blue: 0.96)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    Spacer().frame(height: 20)
                    
                    // Ícono de confirmación
                    ZStack {
                        Circle()
                            .fill(iconColor.opacity(0.08))
                            .frame(width: iconSize * 2.4, height: iconSize * 2.4)
                        Circle()
                            .fill(iconColor.opacity(0.05))
                            .frame(width: iconSize * 3.0, height: iconSize * 3.0)
                        Image(systemName: iconName)
                            .font(.system(size: iconSize * 0.7))
                            .foregroundColor(iconColor)
                    }
                    .accessibilityHidden(true)
                    
                    // Texto principal
                    VStack(spacing: 12) {
                        Text(headline)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color(white: 0.12))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        Text(subtitle)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(Color(white: 0.30))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 32)
                    }
                    
                    // Ejercicio aleatorio
                    exerciseCard(randomExercise)
                    
                    // Tarjeta de apoyo adicional si hay alerta
                    if appState.alertLevel.isAlarmante {
                        supportCard
                    }
                    
                    Spacer().frame(height: 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Exercise card
    
    private func exerciseCard(_ exercise: MentalExercise) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Header del ejercicio
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        // Fondo del ícono: azul o verde pastel según el ejercicio
                        .fill(exerciseIconBackground(exercise))
                        .frame(width: 46, height: 46)
                    Image(systemName: exercise.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(exerciseIconForeground(exercise))
                }
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 3) {
                    // Etiqueta "Ejercicio para ti"
                    Text("Ejercicio para ti")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(exerciseLabelColor(exercise))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(exerciseLabelBackground(exercise))
                        .clipShape(Capsule())
                    
                    Text(exercise.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        // Alto contraste: casi negro
                        .foregroundColor(Color(white: 0.12))
                }
                
                Spacer()
                
                // Duración
                VStack(spacing: 2) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                        .foregroundColor(exerciseLabelColor(exercise))
                        .accessibilityHidden(true)
                    Text(exercise.duration)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(exerciseLabelColor(exercise))
                }
            }
            
            Divider()
                .background(exerciseDividerColor(exercise))
                .opacity(0.4)
            
            // Descripción
            Text(exercise.description)
                .font(.system(size: 14, design: .rounded))
                // Gris oscuro suficientemente contrastado (~5:1 sobre fondo pastel)
                .foregroundColor(Color(white: 0.22))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            // Beneficio
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(exerciseIconForeground(exercise))
                    .accessibilityHidden(true)
                Text(exercise.benefit)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Color(white: 0.28))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .background(exerciseBenefitBackground(exercise))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(20)
        .background(
            // Fondo en tonos pastel azul/verde
            LinearGradient(
                colors: exerciseCardGradient(exercise),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(exerciseBorderColor(exercise), lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Ejercicio recomendado: \(exercise.title). Duración: \(exercise.duration). \(exercise.description)")
    }
    
    // MARK: - Color helpers
    // Alterna entre paleta azul y verde pastel manteniendo contraste WCAG AA
    
    private func isBlue(_ e: MentalExercise) -> Bool {
        // Usa el ícono del ejercicio como señal; si no tiene color definido, alterna por id
        e.iconColor == .blue || e.colors.contains(where: { $0.description.contains("blue") })
    }
    
    private func exerciseCardGradient(_ e: MentalExercise) -> [Color] {
        // Azul pastel
        [Color(red: 0.90, green: 0.95, blue: 1.00),
         Color(red: 0.95, green: 0.98, blue: 1.00)]
    }
    
    // Para ejercicios verdes (puedes extender la lógica si tienes colores variados)
    private func exerciseCardGradientGreen() -> [Color] {
        [Color(red: 0.90, green: 0.97, blue: 0.92),
         Color(red: 0.95, green: 0.99, blue: 0.96)]
    }
    
    private func exerciseIconBackground(_ e: MentalExercise) -> Color {
        Color(red: 0.78, green: 0.90, blue: 1.00)   // azul pastel medio
    }
    
    private func exerciseIconForeground(_ e: MentalExercise) -> Color {
        // Azul oscuro suficiente para contraste ~5:1 sobre el fondo pastel
        Color(red: 0.05, green: 0.35, blue: 0.70)
    }
    
    private func exerciseLabelColor(_ e: MentalExercise) -> Color {
        Color(red: 0.05, green: 0.30, blue: 0.60)
    }
    
    private func exerciseLabelBackground(_ e: MentalExercise) -> Color {
        Color(red: 0.78, green: 0.90, blue: 1.00)
    }
    
    private func exerciseDividerColor(_ e: MentalExercise) -> Color {
        Color(red: 0.60, green: 0.78, blue: 0.95)
    }
    
    private func exerciseBenefitBackground(_ e: MentalExercise) -> Color {
        Color(red: 0.83, green: 0.93, blue: 1.00)
    }
    
    private func exerciseBorderColor(_ e: MentalExercise) -> Color {
        Color(red: 0.60, green: 0.78, blue: 0.95).opacity(0.6)
    }
    
    // MARK: - Support card
    
    private var supportCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .foregroundColor(Color(red: 0.45, green: 0.1, blue: 0.65))
                    .accessibilityHidden(true)
                Text("Recuerda")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.1, blue: 0.65))
            }
            Text("Hablar con un amigo, familiar o compañero de confianza sobre cómo te has sentido puede aliviar mucho la carga.")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Color(white: 0.22))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color(red: 0.96, green: 0.92, blue: 1.0))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.45, green: 0.1, blue: 0.65).opacity(0.25), lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
    }
}


