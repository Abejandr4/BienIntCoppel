import SwiftUI
import UIKit

struct MentalWellnessView: View {
    // Variable de entorno para regresar a la pantalla anterior
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    LinearGradient(
                        colors: [Color.green.opacity(0.9), Color.green.opacity(0.5), Color.orange.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.9)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(spacing: 12) {
                            
                            // Botón de regresar personalizado
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.3))
                                    .clipShape(Circle())
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .padding(.horizontal, 10)
                                
                                VStack(alignment: .leading) {
                                    Text("Bienestar Mental")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, -20)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 100) // Ajuste para el safe area superior
                        .padding(.horizontal, 15)
                    }
                    .padding(.bottom, 25)
                }
                .clipShape(RoundedCorner(radius: 30, corners: [.bottomLeft, .bottomRight]))
                .edgesIgnoringSafeArea(.top)
                
                // MARK: - Components
                VStack(spacing: 10) {
                    CompanyStatsView()
                    StressChartView()
                    Banner(
                        title: "Toma un rápido cuestionario.",
                        description: "Así, puedes llevar una vida más sana a largo plazo.",
                        intensity: 25
                    )
                    RecommendedExerciseView(scoresCuestionario: 50)
                    MentalExercisesView()
                    
                    // MARK: - Progress Notice
                    VStack {
                        Text("\(Image(systemName: "leaf.fill")) Identifica tus emociones ahora para cuidarte de manera autónoma después. Tu progreso activará la siguiente fase y cambiará el color del tema.")
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
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar) // Oculta la barra de navegación predeterminada
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

struct MentalWellnessView_Previews: PreviewProvider {
    static var previews: some View {
        MentalWellnessView()
    }
}
