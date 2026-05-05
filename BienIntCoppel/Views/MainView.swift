import SwiftUI

struct MainView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // MARK: - Header
                HeaderView()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Wellness Section
                    Text("Bienestar Integral")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        WellnessCard(
                            title: "Bienestar Físico",
                            subtitle: "Activa tu cuerpo con rutinas personalizadas",
                            icon: "heart.pulse.fill",
                            iconColor: .orange,
                            bgColor: Color(red: 0.99, green: 0.96, blue: 0.92)
                        )
                        
                        WellnessCard(
                            title: "Bienestar Mental",
                            subtitle: "Gestiona tu estrés y cultiva tu equilibrio",
                            icon: "brain.head.profile",
                            iconColor: .green,
                            bgColor: Color(red: 0.92, green: 0.98, blue: 0.95)
                        )
                        
                        WellnessCard(
                            title: "Bienestar Financiero",
                            subtitle: "Mejora tus finanzas y planifica tu futuro",
                            icon: "dollarsign.circle.fill",
                            iconColor: .yellow,
                            bgColor: Color(red: 1.0, green: 0.98, blue: 0.9)
                        )
                        
                        WellnessCard(
                            title: "Bienestar Social",
                            subtitle: "Conecta con tu comunidad y fortalece lazos",
                            icon: "person.2.fill",
                            iconColor: .blue,
                            bgColor: Color(red: 0.92, green: 0.96, blue: 1.0)
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - AI Section
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
        .background(Color(white: 0.98))
    }
}

// MARK: - Subviews

struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                gradient: Gradient(colors: [Color.orange.opacity(0.6), Color.green.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            
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

struct WellnessCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let bgColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 12).fill(iconColor.opacity(0.1)))
            
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black.opacity(0.8))
            
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
        .background(bgColor)
        .cornerRadius(20)
    }
}

struct AIChatPreviewCard: View {
    var body: some View {
        VStack(spacing: 0) {
            // Chat Bubble
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(LinearGradient(colors: [.orange, .green], startPoint: .top, endPoint: .bottom))
                    .frame(width: 35, height: 35)
                    .overlay(Image(systemName: "robot").foregroundColor(.white).font(.caption))
                
                Text("¡Hola! 👋 Soy tu acompañante de bienestar. ¿En qué puedo ayudarte hoy?")
                    .font(.system(size: 15))
                    .padding()
                    .background(Color(white: 0.95))
                    .cornerRadius(15, corners: [.topRight, .bottomLeft, .bottomRight])
            }
            .padding()
            
            Divider()
            
            // Input Area
            HStack {
                Text("Escribe tu pregunta...")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Capsule().fill(Color(white: 0.96)))
                
                Image(systemName: "paperplane.fill")
                    .padding(10)
                    .background(LinearGradient(colors: [.orange.opacity(0.5), .green.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

// Helper to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
