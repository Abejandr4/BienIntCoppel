import SwiftUI

struct Banner: View {
    // Passed-in variables
    let title: String
    let description: String?
    let intensity: Int
    
    @State private var showQuestionnaire = false
    @State private var isPulsing = false
    
    // Intensity calculation logic
    private var opacityLevel: Double {
        Double(max(0, min(intensity, 100))) / 100.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Content using the passed variables
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
        
        .scaleEffect(isPulsing ? 1.02 : 1.0)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.purple.opacity(opacityLevel * 0.2), lineWidth: 1)
                )
        
        .padding(.horizontal)
        // Presentation logic
        
        .onAppear {
                    withAnimation(
                        .easeInOut(duration: 0.6) // 2 seconds for a soft "breath"
                        .repeatForever(autoreverses: true)
                    ) {
                        isPulsing = true
                    }
                }
        
        .sheet(isPresented: $showQuestionnaire) {
            QuestionnaireContainer(isPresented: $showQuestionnaire)
        }
    }
}

// Wrapper to handle the Navigation and the "Big X"
struct QuestionnaireContainer: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            QuestionnaireView() // Your actual view file
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.secondary)
                        }
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
            VStack(spacing: 20) {
                Banner(
                    title: "Bienestar Espiritual",
                    description: "Encuentra paz interior con sesiones de meditación guiada.",
                    intensity: 80
                )
                
                Banner(
                    title: "Baja Intensidad",
                    description: "Esta es una versión más sutil del banner.",
                    intensity: 20
                )
            }
        }
    }
}
