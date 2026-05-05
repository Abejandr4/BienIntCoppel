import SwiftUI

struct WellnessGrid: View {
    // 1. Configuración de las tarjetas
    let cards = [
        WellnessCard(
            title: "Bienestar Físico",
            description: "Activa tu cuerpo con rutinas personalizadas",
            iconName: "figure.run",
            startColor: Color.orange.opacity(0.15),
            endColor: Color.orange.opacity(0.05),
            iconColor: .orange
        ),
        WellnessCard(
            title: "Bienestar Mental",
            description: "Gestiona tu estrés y cultiva tu equilibrio emocional",
            iconName: "brain.head.profile",
            startColor: Color.emerald.opacity(0.15),
            endColor: Color.emerald.opacity(0.05),
            iconColor: .emerald
        ),
        WellnessCard(
            title: "Bienestar Financiero",
            description: "Mejora tus finanzas y planifica tu futuro",
            iconName: "dollarsign.circle",
            startColor: Color.yellow.opacity(0.15),
            endColor: Color.yellow.opacity(0.05),
            iconColor: .orange
        ),
        WellnessCard(
            title: "Bienestar Social",
            description: "Conecta con tu comunidad y fortalece tus lazos",
            iconName: "person.2",
            startColor: Color.blue.opacity(0.15),
            endColor: Color.blue.opacity(0.05),
            iconColor: .blue
        )
    ]
    
    // 2. Definición de la cuadrícula (2 columnas)
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bienestar Integral")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(cards) { card in
                    NavigationLink(destination: Text(card.title)) {
                        WellnessCardView(card: card)
                    }
                    .buttonStyle(PlainButtonStyle()) // Quita el efecto azul por defecto del Link
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
}

// 3. Subvista para la tarjeta individual
struct WellnessCardView: View {
    let card: WellnessCard
    @State private var isAppearing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Icono
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(card.iconColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: card.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(card.iconColor)
            }
            .padding(.bottom, 4)
            
            // Textos
            Text(card.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(card.description)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 140) // Asegura que todas tengan la misma altura
        .background(
            LinearGradient(
                colors: [card.startColor, card.endColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        // Replicando la animación de Framer Motion
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                isAppearing = true
            }
        }
    }
}
