struct UserHeaderView: View {
    @State private var user: User? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Gradient Background with Rounded Bottom
            LinearGradient(
                colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6), Color.emerald.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedCorner(radius: 32, corners: [.bottomLeft, .bottomRight]))
            .ignoresSafeArea(edges: .top)
            
            // 2. Content
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.6), lineWidth: 2)
                        )
                    
                    Text(user?.initials ?? "U")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                
                // Welcome Text
                VStack(alignment: .leading, spacing: 0) {
                    Text("Bienvenido de vuelta")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("¡Hola \(user?.firstName ?? "Usuario")!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Notification Button
                Button(action: { /* Action */ }) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24) // Spacing from bottom of header
        }
        .frame(height: 140) // Fixed height for header area
        .onAppear {
            fetchUser()
        }
    }
    
    // Faux API Call
    private func fetchUser() {
        // Simulating base44.auth.me()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.user = User(fullName: "Ana Ramírez")
        }
    }
}

// Reusing the RoundedCorner shape from the previous component
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Extension for the emerald color
extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}
