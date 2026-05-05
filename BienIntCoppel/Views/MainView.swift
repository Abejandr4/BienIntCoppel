import SwiftUI

struct MainView: View {
    // Como ya tienes WellnessCardModel en "Models/WellnessCard.swift", lo usamos directamente aquí
    let categories = [
        WellnessCardModel(
            title: "Bienestar Físico",
            description: "Activa tu cuerpo con rutinas personalizadas",
            iconName: "waveform.path.ecg",
            startColor: Color(red: 1.0, green: 0.976, blue: 0.949), // Equivale a FFF9F2
            endColor: Color(red: 1.0, green: 0.945, blue: 0.878),   // Equivale a FFF1E0
            iconColor: .orange,
            destination: AnyView(PhysicalWellnessView()) // Llama a tu PhysicalWellnessView existente
        ),
        WellnessCardModel(
            title: "Bienestar Mental",
            description: "Gestiona tu estrés y cultiva tu equilibrio",
            iconName: "brain.head.profile",
            startColor: Color(red: 0.949, green: 0.98, blue: 0.96), // Equivale a F2FAF5
            endColor: Color(red: 0.878, green: 0.949, blue: 0.913), // Equivale a E0F2E9
            iconColor: .green,
            destination: AnyView(MentalWellnessView()) // Llama a tu MentalWellnessView existente
        ),
        WellnessCardModel(
            title: "Bienestar Financiero",
            description: "Mejora tus finanzas y planifica tu futuro",
            iconName: "dollarsign.circle.fill",
            startColor: Color(red: 1.0, green: 0.988, blue: 0.949), // Equivale a FFFCF2
            endColor: Color(red: 1.0, green: 0.976, blue: 0.878),   // Equivale a FFF9E0
            iconColor: .yellow,
            destination: nil
        ),
        WellnessCardModel(
            title: "Bienestar Social",
            description: "Conecta con tu comunidad y fortalece lazos",
            iconName: "person.2.fill",
            startColor: Color(red: 0.949, green: 0.968, blue: 1.0), // Equivale a F2F7FF
            endColor: Color(red: 0.878, green: 0.913, blue: 1.0),   // Equivale a E0E9FF
            iconColor: .blue,
            destination: nil
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    HeaderView()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Tu Bienestar Integral")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding(.horizontal)
                            .padding(.top, 40)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(categories) { item in
                                if let dest = item.destination {
                                    NavigationLink(destination: dest) {
                                        WellnessCardView(data: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    WellnessCardView(data: item)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // banner
                        Banner(
                            title: "Toma un rápido cuestionario.",
                            description: "Así, puedes llevar una vida más sana a largo plazo.",
                            intensity: 20
                        )
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

// MARK: - Componentes de Vista Complementarios

struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.orange.opacity(0.7), Color.green.opacity(0.5)],
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

struct WellnessCardView: View {
    let data: WellnessCardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: data.iconName)
                .font(.title2)
                .foregroundColor(data.iconColor)
                .padding(10)
                .background(Circle().fill(data.iconColor.opacity(0.15)))
            
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

#Preview {
    MainView()
}

#Preview {
    MainView()
}
