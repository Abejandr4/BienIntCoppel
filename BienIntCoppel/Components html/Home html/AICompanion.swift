import SwiftUI

// 1. Data Model
struct Message: Identifiable, Equatable {
    let id = UUID()
    let role: MessageRole
    let content: String
}

enum MessageRole {
    case user
    case assistant
}

struct AICompanionView: View {
    @State private var messages: [Message] = [
        Message(role: .assistant, content: "¡Hola! 👋 Soy tu acompañante de bienestar. ¿En qué puedo ayudarte hoy?")
    ]
    @State private var inputText: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue) // Assuming primary color
                Text("Tu Acompañante AI")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 20)
            
            // Chat Container
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(messages) { msg in
                                MessageBubble(message: msg)
                                    .id(msg.id)
                            }
                            
                            if isLoading {
                                LoadingBubble()
                                    .id("loading")
                            }
                        }
                        .padding(16)
                    }
                    .frame(minHeight: 140, maxHeight: 260)
                    .onChange(of: messages) { _ in
                        withAnimation { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                    }
                }
                
                // Input Area
                Divider()
                HStack(spacing: 10) {
                    TextField("Escribe tu pregunta...", text: $inputText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .font(.subheadline)
                        .onSubmit(handleSend)
                    
                    Button(action: handleSend) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                LinearGradient(colors: [.orange, .emerald], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(12)
                            .opacity(inputText.isEmpty || isLoading ? 0.4 : 1.0)
                    }
                    .disabled(inputText.isEmpty || isLoading)
                }
                .padding(12)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 5)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    // 2. Faux LLM Logic
    private func handleSend() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMsg = Message(role: .user, content: inputText)
        withAnimation(.easeOut(duration: 0.3)) {
            messages.append(userMsg)
            inputText = ""
            isLoading = true
        }
        
        // Faux API Call
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5s delay
            
            let responseText = "Entiendo que estés buscando apoyo. Como tu asistente de Coppel, estoy aquí para escucharte y ofrecerte recursos de bienestar."
            
            withAnimation(.easeOut(duration: 0.3)) {
                messages.append(Message(role: .assistant, content: responseText))
                isLoading = false
            }
        }
    }
}

// 3. Subviews
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.role == .assistant {
                BotAvatar()
            } else {
                Spacer()
            }
            
            Text(message.content)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.role == .user ? Color.blue : Color(.systemGray6))
                .foregroundColor(message.role == .user ? .white : .primary)
                .clipShape(RoundedCorner(radius: 16, corners: message.role == .user ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight]))
            
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

struct LoadingBubble: View {
    var body: some View {
        HStack(spacing: 8) {
            BotAvatar()
            HStack(spacing: 4) {
                DotView(delay: 0)
                DotView(delay: 0.2)
                DotView(delay: 0.4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            Spacer()
        }
    }
}

struct BotAvatar: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange, .emerald], startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: "cpu") // Using CPU as a Bot placeholder
                .font(.system(size: 10))
                .foregroundColor(.white)
        }
        .frame(width: 28, height: 28)
        .clipShape(Circle())
        .padding(.top, 2)
    }
}

struct DotView: View {
    @State private var scale: CGFloat = 0.5
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.4))
            .frame(width: 6, height: 6)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay)) {
                    scale = 1.0
                }
            }
    }
}

// Helper for specific corner rounding
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
