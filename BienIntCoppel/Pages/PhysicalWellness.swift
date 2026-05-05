import SwiftUI

// MARK: - View
struct PhysicalWellnessView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                
                VStack(spacing: 24) {
                    // Components follow the spacing and background logic
                    CompanyStatsView()
                    StressChartView()
                    QuestionnaireView()
                    MentalExercisesView()
                    
                    progressNoticeSection
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(.white))
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        ZStack {
            // Gradient: Emerald -> Yellow -> Orange
            LinearGradient(
                colors: [
                    Color(hex: "34D399"),
                    Color(hex: "FCD34D"),
                    Color(hex: "FDBA74")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.9)
            
            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.white)
                        VStack(alignment: .leading) {
                            Text("Bienestar Mental")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Fase 1 — Identificación")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal)
            }
            .padding(.bottom, 25)
        }
        // Native SwiftUI way to round only bottom corners (iOS 16+)
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 30, bottomTrailingRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "34D399"), Color(hex: "FCD34D"), Color(hex: "FDBA74")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
    }
    
    private var progressNoticeSection: some View {
        VStack {
            Text("🌱 Identifica tus emociones ahora para cuidarte de manera autónoma después. Tu progreso activará la siguiente fase y cambiará el color del tema.")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.05), Color.green.opacity(0.05)],
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
    }
}

// MARK: - Color Hex Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

