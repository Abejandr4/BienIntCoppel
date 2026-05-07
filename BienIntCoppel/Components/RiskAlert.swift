import SwiftUI

struct RiskAlertBanner: View {
    @ObservedObject var store: QuestionnaireStore
    @Binding var showContactsView: Bool
    @Binding var isVisible: Bool
    
    // Auto-dismiss timer
    let displaySeconds: Double = 8
    @State private var timeRemaining: Double = 1.0  // progreso 1 → 0
    @State private var timerTask: Task<Void, Never>? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Barra de progreso del timer
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.pink.opacity(0.15))
                        .frame(height: 3)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.pink, Color.purple.opacity(0.7)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * timeRemaining, height: 3)
                        .animation(.linear(duration: 0.1), value: timeRemaining)
                }
            }
            .frame(height: 3)
            .padding(.bottom, 12)
            
            // Contenido
            HStack(alignment: .top, spacing: 12) {
                
                // Ícono
                ZStack {
                    Circle()
                        .fill(Color.pink.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "heart.text.clipboard")
                        .font(.system(size: 18))
                        .foregroundColor(.pink)
                }
                
                // Texto
                VStack(alignment: .leading, spacing: 4) {
                    Text("Te recomendamos hablar con alguien")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text(store.riskLevel.mensaje)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(2)
                }
                
                Spacer()
                
                // Botón X
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                        .padding(6)
                        .background(Circle().fill(Color.secondary.opacity(0.1)))
                }
            }
            
            // Botón de acción
            Button {
                showContactsView = true
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 13))
                    Text("Ver contactos de apoyo")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.85), Color.purple.opacity(0.7)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top, 12)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.pink.opacity(0.15), radius: 16, x: 0, y: 6)
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.pink.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .onAppear { startTimer() }
        .onDisappear { timerTask?.cancel() }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timeRemaining = 1.0
        timerTask?.cancel()
        timerTask = Task {
            let steps = 80
            let interval = displaySeconds / Double(steps)
            let decrement = 1.0 / Double(steps)
            
            for _ in 0..<steps {
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                if Task.isCancelled { return }
                await MainActor.run {
                    timeRemaining -= decrement
                }
            }
            await MainActor.run { dismiss() }
        }
    }
    
    private func dismiss() {
        timerTask?.cancel()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isVisible = false
        }
    }
}

#Preview {
    ZStack(alignment: .top) {
        // Fondo para simular la app detrás del banner
        Color(red: 253/255, green: 251/255, blue: 246/255)
            .ignoresSafeArea()
        
        RiskAlertBanner(
            store: QuestionnaireStore(),
            showContactsView: .constant(false),
            isVisible: .constant(true)
        )
        .padding(.top, 30)
    }
}
