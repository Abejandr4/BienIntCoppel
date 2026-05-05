import SwiftUI

struct Banner: View {
    let title: String
    let description: String?
    let intensity: Int
    let shouldPulse: Bool // New control variable
    
    @State private var showQuestionnaire = false
    @State private var isPulsing = false
    
    // Intensity calculation logic
    private var opacityLevel: Double {
        Double(max(0, min(intensity, 100))) / 100.0
    }

    // Default initializer to make 'shouldPulse' false by default
    init(title: String, description: String?, intensity: Int, shouldPulse: Bool = false) {
        self.title = title
        self.description = description
        self.intensity = intensity
        self.shouldPulse = shouldPulse
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.indigo.opacity(0.9))
                
                if let description {
                    Text(description)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.indigo.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Button(action: { showQuestionnaire = true }) {
                Text("Comenzar")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.indigo.opacity(opacityLevel + 0.2))
                    .cornerRadius(14)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.purple.opacity(opacityLevel * 0.2), Color.blue.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        // Pulse logic based on State
        .scaleEffect(isPulsing ? 1.02 : 1.0)
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.purple.opacity(opacityLevel * 0.2), lineWidth: 1)
        )
        .padding(.horizontal)
        .onAppear {
            // Only trigger animation if the constant is true
            if shouldPulse {
                withAnimation(
                    .easeInOut(duration: 0.8)
                    .repeatForever(autoreverses: true)
                ) {
                    isPulsing = true
                }
            }
        }
        .sheet(isPresented: $showQuestionnaire) {
            QuestionnaireContainer(isPresented: $showQuestionnaire)
        }
    }
}

// Wrapper to handle the Navigation and the "Big X"
// Wrapper to handle the Navigation and the "Big X"
struct QuestionnaireContainer: View {
    @Binding var isPresented: Bool // Binding ensures the state is shared with the Banner
    
    var body: some View {
        NavigationStack {
            QuestionnaireView() // This is where the AI-generated questions will appear
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // The "Big X" button to opt out and dismiss the view
                        Button(action: { isPresented = false }) { // Directly toggles the sheet visibility
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.secondary)
                        }
                        .accessibilityLabel("Cerrar cuestionario") // Accessibility for users
                    }
                }
        }
    }
}

// MARK: - Preview
struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(white: 0.98).ignoresSafeArea()
            VStack(spacing: 30) {
                
                Text("Banner Estático (Default)")
                    .font(.caption).bold().foregroundColor(.secondary)
                
                // Static version
                Banner(
                    title: "Paz Interior",
                    description: "Este banner no se mueve por defecto.",
                    intensity: 40
                )
                
                Divider().padding()
                
                Text("Banner con Movimiento (Pulsing)")
                    .font(.caption).bold().foregroundColor(.secondary)
                
                // Animated version
                Banner(
                    title: "Alerta de Riesgo",
                    description: "Este banner utiliza el parámetro shouldPulse: true.",
                    intensity: 90,
                    shouldPulse: true
                )
            }
        }
    }
}
