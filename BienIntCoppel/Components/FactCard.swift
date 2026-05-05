import SwiftUI
internal import Combine

struct FactCardView: View {
    let ficha: FichaInformativa
    
    let blueGradient = LinearGradient(
        colors: [Color(hex: "0033FF"), Color(hex: "00A6FF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )


    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header con Icon
            HStack {
                Text(ficha.boldText)
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .foregroundStyle(.yellow)
                
                Spacer()
                
                Image(systemName: "lightbulb.fill") // Replace with Image(ficha.image)
                    .font(.title)
                    .foregroundStyle(.yellow)
            }
            
            // Main Fact Text
            Text(ficha.normalText)
                .font(.system(.body, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineSpacing(4)
            
            // Decorative Graphic Element (3 out of 4)
            HStack(spacing: 8) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index < 3 ? Color.yellow : Color.white.opacity(0.3))
                        .frame(width: 12, height: 12)
                }
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(blueGradient)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .frame(maxWidth: 350)
    }
}

// Helper to use Hex colors easily
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct RandomFactCard: View {
    let fichas: [FichaInformativa]
    
    // State to hold the current visible fact
    @State private var currentFicha: FichaInformativa?
    
    // Timer set for 180 seconds (3 minutes)
    let timer = Timer.publish(every: 180, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if let ficha = currentFicha {
                // We use our previously built FactCardView
                FactCardView(ficha: ficha)
                    // Added a transition for a smoother "swap" feel
                    .id(ficha.id)
                    .transition(.asymmetric(insertion: .push(from: .trailing), removal: .opacity))
            }
        }
        .onAppear {
            // Pick a random fact when the view first loads
            if currentFicha == nil {
                currentFicha = fichas.randomElement()
            }
        }
        .onReceive(timer) { _ in
            // Change the fact every 3 minutes
            withAnimation(.spring()) {
                currentFicha = fichas.randomElement()
            }
        }
    }
}

// Preview Provider
struct FactCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            FactCardView(ficha: FichaInformativa(
                id: "H-A",
                boldText: "¿Sabías que...",
                normalText: "3 de cada 4 mexicanos sufre de estrés laboral agudo.",
                image: "3de4"
            ))
        }
    }
}
