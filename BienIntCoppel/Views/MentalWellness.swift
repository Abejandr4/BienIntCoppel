import SwiftUI
import UIKit


struct MentalWellnessView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    LinearGradient(
                        colors: [Color.green.opacity(0.8), Color.green.opacity(0.4), Color.orange.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.9)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(spacing: 12) {
                            Button(action: {
                                // Action to dismiss or go back
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                VStack(alignment: .leading) {
                                    Text("Bienestar Mental")
                                        .font(.title)
                                                                    .fontWeight(.bold)
                                                                    .foregroundColor(.white)
                                    Text("Fase 1 — Identificación")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        .padding(.top, 80)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 25)
                }
                .clipShape(RoundedCorner(radius: 30, corners: [.bottomLeft, .bottomRight]))
                .edgesIgnoringSafeArea(.top)

                // MARK: - Components
                VStack(spacing: 10) {
                    // Note: These views were created in previous steps
                    
                    // 1. Company Stats (Placeholder for the component)
                    CompanyStatsView()
                    
                    // 2. Stress Chart (Placeholder for the component)
                    StressChartView()
                    
                    // 3. Questionnaire
                    QuestionnaireView()
                    
                    // 4. Mental Exercises
                    MentalExercisesView()
                    
                    // MARK: - Progress Notice
                    VStack {
                        Text("🌱 Identifica tus emociones ahora para cuidarte de manera autónoma después. Tu progreso activará la siguiente fase y cambiará el color del tema.")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(16)
                            .background(
                                LinearGradient(
                                    colors: [Color.orange.opacity(0.05), Color.yellow.opacity(0.05), Color.green.opacity(0.05)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.orange.opacity(0.1), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - RoundedCorner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Local Placeholders for parent components
// Replace these with your actual implementations if they exist as separate files

struct CompanyStatsView: View {
    var body: some View {
        Text("Estadísticas de Empresa")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding()
    }
}

struct StressChartView: View {
    var body: some View {
        Text("Gráfica de Estrés")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding()
    }
}

// MARK: - Preview
struct MentalWellnessView_Previews: PreviewProvider {
    static var previews: some View {
        MentalWellnessView()
    }
}
