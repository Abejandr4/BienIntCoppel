import SwiftUI

// MARK: - MainView Refactorizado
struct MainView: View {
    let categories = [
        WellnessCardModel(
            title: "Bienestar Físico",
            description: "Tus rutinas personalizadas",
            iconName: "waveform.path.ecg",
            startColor: Color(red: 1.0, green: 0.96, blue: 0.90),
            endColor: Color(red: 1.0, green: 0.90, blue: 0.80),
            // Naranja un poco más vibrante/oscuro para contrastar con el blanco
            iconColor: Color(red: 0.9, green: 0.4, blue: 0.0),
            destination: AnyView(PhysicalWellnessView())
        ),
        WellnessCardModel(
            title: "Bienestar Mental",
            description: "Tu equilibrio",
            iconName: "brain.head.profile",
            startColor: Color(red: 0.92, green: 0.98, blue: 0.94),
            endColor: Color(red: 0.82, green: 0.94, blue: 0.87),
            // Verde más profundo
            iconColor: Color(red: 0.0, green: 0.6, blue: 0.2),
            destination: AnyView(MentalWellnessView())
        ),
        WellnessCardModel(
            title: "Bienestar Financiero",
            description: "Tus finanzas y planificación",
            iconName: "dollarsign.circle",
            startColor: Color(red: 1.0, green: 0.98, blue: 0.90),
            endColor: Color(red: 1.0, green: 0.94, blue: 0.75),
            // Dorado (en lugar de amarillo chillón) para que se lea bien sobre blanco
            iconColor: Color(red: 0.8, green: 0.6, blue: 0.0),
            destination: nil
        ),
        WellnessCardModel(
            title: "Bienestar Social",
            description: "Tu comunidad y tus lazos",
            iconName: "person.2",
            startColor: Color(red: 0.90, green: 0.95, blue: 1.0),
            endColor: Color(red: 0.80, green: 0.88, blue: 1.0),
            // Azul más profundo
            iconColor: Color(red: 0.0, green: 0.4, blue: 0.8),
            destination: nil
        )
    ]

    let backgroundColor = Color(red: 253/255, green: 251/255, blue: 246/255)
    let textColorDark = Color(red: 43/255, green: 43/255, blue: 43/255)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        HeaderView()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // NUEVA VISTA: Mini vista animada encima de los botones
                            AnimatedParticleCard()
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            
                            Text("Tu Bienestar Integral")
                                .font(.custom("Poppins-Bold", size: 22))
                                .foregroundColor(textColorDark)
                                .padding(.horizontal)
                            
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 20),
                                    GridItem(.flexible())
                                ],
                                spacing: 20
                            ) {
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
                            
                            Text("Noticias Coppel")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(textColorDark)
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            CoppelNewsCarousel()
                                .padding(.bottom, 30)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
}

// MARK: - Mini Vista Animada (Partículas)
struct AnimatedParticleCard: View {
    @State private var isAnimating = false
    let particleCount = 15 // Cantidad de círculos flotantes

    var body: some View {
        ZStack {
            // Fondo de la tarjeta (un gradiente suave)
            LinearGradient(
                colors: [Color(red: 0.88, green: 0.93, blue: 1.0), Color(red: 0.95, green: 0.88, blue: 0.98)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Partículas animadas
            GeometryReader { geometry in
                ForEach(0..<particleCount, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.2...0.6)))
                        .frame(width: CGFloat.random(in: 20...70))
                        // Posición inicial y final aleatoria dentro de la tarjeta
                        .position(
                            x: isAnimating ? CGFloat.random(in: 0...geometry.size.width) : CGFloat.random(in: 0...geometry.size.width),
                            y: isAnimating ? CGFloat.random(in: 0...geometry.size.height) : CGFloat.random(in: 0...geometry.size.height)
                        )
                        // Animación lenta, fluida e infinita
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 6...12))
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...2)),
                            value: isAnimating
                        )
                }
            }
            .clipped() // Para que los círculos no se salgan de la tarjeta
            
            // Placeholder para tu futura animación
            VStack {
                Text("Espacio reservado para tu animación")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(Color.black.opacity(0.4))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(Color.black.opacity(0.2))
                    )
            }
        }
        .frame(height: 200) // Altura de la mini vista
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        .onAppear {
            // Disparamos la animación en cuanto aparece la vista
            isAnimating = true
        }
    }
}

// MARK: - Tarjeta de Bienestar
struct WellnessCardView: View {
    let data: WellnessCardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            // Círculo blanco sólido para máximo contraste
            Image(systemName: data.iconName)
                .font(.system(size: 20, weight: .semibold)) // Ícono más grueso (.semibold)
                .foregroundColor(data.iconColor)
                .frame(width: 44, height: 44) // Tamaño fijo para que el círculo sea perfecto
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: data.iconColor.opacity(0.3), radius: 5, x: 0, y: 3) // Su propia sombra
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(data.title)
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(Color(red: 43/255, green: 43/255, blue: 43/255))
                
                Text(data.description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Color(red: 90/255, green: 90/255, blue: 90/255))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
        .background(
            LinearGradient(colors: [data.startColor, data.endColor], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(20)
        .shadow(color: data.iconColor.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Carrusel de Noticias con Fotos
struct CoppelNewsCarousel: View {
    struct NewsItem: Identifiable {
        let id = UUID()
        let title: String
        let imageName: String
        let fallbackColor: Color
    }
    
    let newsItems = [
        NewsItem(title: "Nueva actualización de beneficios", imageName: "noticia1", fallbackColor: Color(red: 5/255, green: 41/255, blue: 122/255)),
        NewsItem(title: "Resultados del Maratón 2026", imageName: "noticia2", fallbackColor: Color(red: 10/255, green: 191/255, blue: 79/255)),
        NewsItem(title: "Feria de Salud en CEDIS", imageName: "noticia3", fallbackColor: Color(red: 200/255, green: 24/255, blue: 13/255))
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(newsItems) { item in
                    ZStack(alignment: .bottomLeading) {
                        
                        Image(item.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 260, height: 140)
                            .background(item.fallbackColor)
                            .clipped()
                            .cornerRadius(16)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [.black.opacity(0.8), .clear], startPoint: .bottom, endPoint: .center))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ÚLTIMA HORA")
                                .font(.custom("Poppins-Bold", size: 10))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.9))
                                .clipShape(Capsule())
                            
                            Text(item.title)
                                .font(.custom("Poppins-SemiBold", size: 15))
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                        .padding(14)
                    }
                    .frame(width: 260, height: 140)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - HeaderView
struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.orange.opacity(0.9), Color.green.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 180)
            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
            
            HStack(alignment: .center) {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(Text("VG").font(.custom("Poppins-Bold", size: 18)).foregroundColor(.white))
                
                VStack(alignment: .leading) {
                    Text("¡Hola Vale!")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .semibold)) // Campana delineada pero más gruesa
                    .padding(12)
                    .background(Circle().fill(Color.white.opacity(0.3)))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    MainView()
}
