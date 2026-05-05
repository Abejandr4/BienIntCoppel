import SwiftUI
internal import Combine

// MARK: - MainView Refactorizado
struct MainView: View {
    let categories = [
        WellnessCardModel(
            title: "Bienestar Físico",
            description: "Tus rutinas personalizadas",
            iconName: "waveform.path.ecg",
            startColor: Color(red: 1.0, green: 0.96, blue: 0.90),
            endColor: Color(red: 1.0, green: 0.90, blue: 0.80),
            iconColor: Color(red: 0.9, green: 0.4, blue: 0.0),
            destination: AnyView(PhysicalWellnessView())
        ),
        WellnessCardModel(
            title: "Bienestar Mental",
            description: "Tu equilibrio",
            iconName: "brain.head.profile",
            startColor: Color(red: 0.92, green: 0.98, blue: 0.94),
            endColor: Color(red: 0.82, green: 0.94, blue: 0.87),
            iconColor: Color(red: 0.0, green: 0.6, blue: 0.2),
            destination: AnyView(MentalWellnessView())
        ),
        WellnessCardModel(
            title: "Bienestar Financiero",
            description: "Tus finanzas y planificación",
            iconName: "dollarsign.circle",
            startColor: Color(red: 1.0, green: 0.98, blue: 0.90),
            endColor: Color(red: 1.0, green: 0.94, blue: 0.75),
            iconColor: Color(red: 0.8, green: 0.6, blue: 0.0),
            destination: nil
        ),
        WellnessCardModel(
            title: "Bienestar Social",
            description: "Tu comunidad y tus lazos",
            iconName: "person.2",
            startColor: Color(red: 0.90, green: 0.95, blue: 1.0),
            endColor: Color(red: 0.80, green: 0.88, blue: 1.0),
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
                            
                            // Tarjeta animada con Coppelia, nube de pensamiento y botón
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

// MARK: - Contenedor Principal de la Tarjeta Animada
struct AnimatedParticleCard: View {
    @EnvironmentObject var appState: AppState
    @State private var showQuestionnaire = false
    
    let animatedImages = ["Coppelia1", "Coppelia2", "Coppelia3", "Coppelia4", "Coppelia5"]
    
    // Mensajes mixtos: tips de bienestar + normalización de salud mental
    let thoughts = [
        "Pedir ayuda también es de valientes",
        "Recuerda tomar agua hoy",
        "Ir a terapia es cuidarte, igual que ir al doctor",
        "Una pausa activa hace magia",
        "Tus emociones son válidas, todas",
        "Hablar de lo que sientes te libera",
        "Descansar también es productivo",
        "No tienes que estar bien todo el tiempo",
        "Sonríe, te ves increíble hoy"
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 12) {
            // Tarjeta con animación + nube
            ZStack {
                // 1. Fondo de partículas
                ParticleBackgroundView()
                
                // 2. Imagen a la izquierda + nube a la derecha
                HStack(alignment: .center, spacing: 0) {
                    SmoothImageSequenceView(
                        images: animatedImages,
                        currentIndex: $currentIndex
                    )
                    .frame(width: 180, height: 180)
                    
                    ThoughtBubbleView(text: thoughts[currentIndex % thoughts.count])
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 16)
                
            }
            .frame(height: 240)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
            
            // Botón debajo de la nube → navega al cuestionario
            Button(action: { showQuestionnaire = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "heart.text.square")
                        .font(.system(size: 24, weight: .semibold))
                        Text("¿Cómo te sientes hoy?")
                            .font(.custom("Poppins-SemiBold", size: 16))
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                    }
                        .font(.system(size: 14, weight: .bold))
                
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.62, green: 0.55, blue: 0.85),  // lila (color de la nube)
                            Color(red: 0.50, green: 0.45, blue: 0.78)   // lila más profundo
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color(red: 0.62, green: 0.55, blue: 0.85).opacity(0.35), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $showQuestionnaire) {
            QuestionnaireView()
                .environmentObject(appState)
        }
        
    }
}

// MARK: - Nube de Pensamiento con efecto Typing
struct ThoughtBubbleView: View {
    let text: String
    
    @State private var displayedText: String = ""
    @State private var showCursor: Bool = true
    @State private var appear: Bool = false
    @State private var typingTask: Task<Void, Never>? = nil
    
    let accentColor = Color(red: 0.62, green: 0.55, blue: 0.85)
    
    // Separa el texto principal del emoji final (si existe)
    private var splitText: (body: String, emoji: String) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        if let last = trimmed.last, last.isEmoji {
            let body = String(trimmed.dropLast()).trimmingCharacters(in: .whitespaces)
            return (body, String(last))
        }
        return (trimmed, "")
    }
    
    var body: some View {
        // ZStack para poder posicionar las burbujitas en diagonal
        ZStack(alignment: .topLeading) {
            
            // 👇 BURBUJITAS DE PENSAMIENTO (ajusta su posición global aquí)
            ThoughtTrail(accentColor: accentColor)
                .offset(x: -8, y: 85)
            // ⬅️ MUEVE TODA la trayectoria: x = horizontal, y = vertical
            
            // Nube principal
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                
                (Text(displayedText)
                    .font(.custom("Poppins-SemiBold", size: 13))
                 + Text(displayedText.count >= splitText.body.count && !splitText.emoji.isEmpty ? " \(splitText.emoji)" : "")
                    .font(.system(size: 13)))
                .foregroundColor(Color(red: 50/255, green: 50/255, blue: 60/255))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                
                if displayedText.count < splitText.body.count {
                    Rectangle()
                        .fill(accentColor)
                        .frame(width: 1, height: 13)
                        .opacity(showCursor ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(), value: showCursor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .frame(maxWidth: 175, alignment: .leading)
            .background(
                OrganicBubbleShape()
                    .fill(Color.white)
                    .overlay(
                        OrganicBubbleShape()
                            .stroke(accentColor.opacity(0.18), lineWidth: 1)
                    )
                    .shadow(color: accentColor.opacity(0.12), radius: 8, x: 0, y: 3)
                    .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
            )
            .padding(.leading, 22) // Espacio reservado para que se vean las burbujitas a la izquierda
        }
        .opacity(appear ? 1 : 0)
        .scaleEffect(appear ? 1 : 0.85, anchor: .bottomLeading)
        .onAppear {
            startTyping()
            showCursor = true
        }
        .onChange(of: text) { _, _ in
            restartTyping()
        }
    }
    
    private func startTyping() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            appear = true
        }
        
        typingTask?.cancel()
        displayedText = ""
        
        typingTask = Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            
            for character in splitText.body {
                if Task.isCancelled { return }
                await MainActor.run {
                    displayedText.append(character)
                }
                let delay: UInt64 = (character == "," || character == ".") ? 250_000_000 : 80_000_000
                try? await Task.sleep(nanoseconds: delay)
            }
        }
    }
    
    private func restartTyping() {
        withAnimation(.easeInOut(duration: 0.25)) {
            appear = false
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            await MainActor.run {
                startTyping()
            }
        }
    }
}

// MARK: - Trayectoria de pensamiento (burbujitas en diagonal ascendente)
struct ThoughtTrail: View {
    let accentColor: Color
    @State private var pulse: Bool = false
    
    var body: some View {
        ZStack {

            Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(accentColor.opacity(0.2), lineWidth: 0.5))
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                .frame(width: 6, height: 6)        // ⬅️ TAMAÑO burbuja 1
                .offset(x: -30, y: -40)                // ⬅️ POSICIÓN burbuja 1
                .opacity(pulse ? 1.0 : 0.7)
            
            Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(accentColor.opacity(0.2), lineWidth: 0.5))
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                .frame(width: 10, height: 10)      // ⬅️ TAMAÑO burbuja 2
                .offset(x: -10, y: -50)             // ⬅️ POSICIÓN burbuja 2 (10 a la derecha, 14 arriba)
                .opacity(pulse ? 0.85 : 1.0)
           
            Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(accentColor.opacity(0.2), lineWidth: 0.5))
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                .frame(width: 14, height: 14)      // ⬅️ TAMAÑO burbuja 3
                .offset(x: 10, y: -60)             // ⬅️ POSICIÓN burbuja 3 (24 a la derecha, 30 arriba)
                .opacity(pulse ? 1.0 : 0.8)
        }
        .animation(
            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
            value: pulse
        )
        .onAppear { pulse = true }
    }
}

// MARK: - Forma de Nube Orgánica (esquinas suavemente asimétricas)
struct OrganicBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Radios ligeramente diferentes en cada esquina para un look orgánico
        let topLeft: CGFloat = 18
        let topRight: CGFloat = 22
        let bottomRight: CGFloat = 20
        let bottomLeft: CGFloat = 14
        
        // Top-left
        path.move(to: CGPoint(x: topLeft, y: 0))
        // Top edge
        path.addLine(to: CGPoint(x: w - topRight, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: w, y: topRight),
            control: CGPoint(x: w, y: 0)
        )
        // Right edge
        path.addLine(to: CGPoint(x: w, y: h - bottomRight))
        path.addQuadCurve(
            to: CGPoint(x: w - bottomRight, y: h),
            control: CGPoint(x: w, y: h)
        )
        // Bottom edge
        path.addLine(to: CGPoint(x: bottomLeft, y: h))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h - bottomLeft),
            control: CGPoint(x: 0, y: h)
        )
        // Left edge
        path.addLine(to: CGPoint(x: 0, y: topLeft))
        path.addQuadCurve(
            to: CGPoint(x: topLeft, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Helper: detectar si un Character es emoji
extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }
}

// MARK: - COMPONENTE 1: Fondo de Partículas Independiente
struct ParticleBackgroundView: View {
    @State private var isAnimating = false
    let particleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.88, green: 0.93, blue: 1.0), Color(red: 0.95, green: 0.88, blue: 0.98)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                ForEach(0..<particleCount, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.2...0.6)))
                        .frame(width: CGFloat.random(in: 20...70))
                        .position(
                            x: isAnimating ? CGFloat.random(in: 0...geometry.size.width) : CGFloat.random(in: 0...geometry.size.width),
                            y: isAnimating ? CGFloat.random(in: 0...geometry.size.height) : CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 15...25))
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...2)),
                            value: isAnimating
                        )
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - COMPONENTE 2: Animación de Imágenes (sincronizada con el padre)
struct SmoothImageSequenceView: View {
    let images: [String]
    @Binding var currentIndex: Int
    
    let timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ForEach(0..<images.count, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFit()
                    .opacity(currentIndex == index ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1), value: currentIndex)
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }
}

// MARK: - Tarjeta de Bienestar
struct WellnessCardView: View {
    let data: WellnessCardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: data.iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(data.iconColor)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: data.iconColor.opacity(0.3), radius: 5, x: 0, y: 3)
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
                
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppState())
}
