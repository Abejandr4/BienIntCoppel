import SwiftUI

// MARK: - 1. Model
struct WellnessCardModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let startColor: Color
    let endColor: Color
    let iconColor: Color
}

// MARK: - 2. Main View
struct MainView: View {
    // Sample Data using your new Model structure
    let categories = [
        WellnessCardModel(title: "Bienestar Físico", description: "Activa tu cuerpo con rutinas personalizadas", iconName: "heart.pulse.fill", startColor: Color(hex: "FFF9F2"), endColor: Color(hex: "FFF1E0"), iconColor: .orange),
        WellnessCardModel(title: "Bienestar Mental", description: "Gestiona tu estrés y cultiva tu equilibrio", iconName: "brain.head.profile", startColor: Color(hex: "F2FAF5"), endColor: Color(hex: "E0F2E9"), iconColor: .green),
        WellnessCardModel(title: "Bienestar Financiero", description: "Mejora tus finanzas y planifica tu futuro", iconName: "dollarsign.circle.fill", startColor: Color(hex: "FFFCF2"), endColor: Color(hex: "FFF9E0"), iconColor: .yellow),
        WellnessCardModel(title: "Bienestar Social", description: "Conecta con tu comunidad y fortalece lazos", iconName: "person.2.fill", startColor: Color(hex: "F2F7FF"), endColor: Color(hex: "E0E9FF"), iconColor: .blue)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                HeaderView()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Bienestar Integral")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(categories) { item in
                            WellnessCardView(data: item)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.orange)
                        Text("Tu Acompañante AI")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    AIChatPreviewCard()
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 30)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.primary.opacity(0.02).ignoresSafeArea())
    }
}

// MARK: - 3. Header View
struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.orange.opacity(0.6), Color.green.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
            
            HStack(alignment: .center) {
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 50, height: 50)
                    .overlay(Text("VG").fontWeight(.bold).foregroundColor(.white))
                
                VStack(alignment: .leading) {
                    Text("Bienvenido de vuelta")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    Text("¡Hola Vale!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "bell.fill")
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.3)))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 30)
        }
    }
}

// MARK: - 4. Wellness Card View
struct WellnessCardView: View {
    let data: WellnessCardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: data.iconName)
                .font(.title2)
                .foregroundColor(data.iconColor)
                .padding(10)
                .background(Circle().fill(data.iconColor.opacity(0.1)))
            
            Text(data.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary.opacity(0.8))
            
            Text(data.description)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
        .background(
            LinearGradient(colors: [data.startColor, data.endColor], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(20)
    }
}

// MARK: - 5. AI Chat Card
struct AIChatPreviewCard: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(LinearGradient(colors: [.orange, .green], startPoint: .top, endPoint: .bottom))
                    .frame(width: 35, height: 35)
                    .overlay(Image(systemName: "robot").foregroundColor(.white).font(.caption))
                
                Text("¡Hola! 👋 Soy tu acompañante de bienestar. ¿En qué puedo ayudarte hoy?")
                    .font(.system(size: 15))
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    // FIXED: Replaced UIKit corners with Pure SwiftUI UnevenRoundedRectangle
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 2, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 15))
            }
            .padding()
            
            Divider()
            
            HStack {
                Text("Escribe tu pregunta...")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Capsule().fill(Color.secondary.opacity(0.05)))
                
                Image(systemName: "paperplane.fill")
                    .padding(10)
                    .background(Color.orange.opacity(0.2))
                    .clipShape(Circle())
                    .foregroundColor(.orange)
            }
            .padding()
        }
        .background(Color.primary.opacity(0.0).background(Material.thin)) // Pure SwiftUI background
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
