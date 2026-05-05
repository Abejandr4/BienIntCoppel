import SwiftUI

struct ComunidadView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack(alignment: .bottomLeading) {
                    // Background Gradient with Mesh-like feel
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.98, green: 0.64, blue: 0.40), // orange-400
                            Color(red: 0.99, green: 0.85, blue: 0.47), // amber-300
                            Color(red: 0.66, green: 0.91, blue: 0.80)  // emerald-300
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.9)
                    .frame(height: 140)
                    
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Comunidad")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Comparte tus logros de bienestar")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Action Button (Plus)
                        Button(action: {
                            // Create post action
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 25)
                }
                .edgesIgnoringSafeArea(.top)
                
                // MARK: - Components
                VStack(spacing: 20) {
                    // Stories Component
                    StoriesView()
                        .padding(.top, 20)
                    
                    // Post Feed Component
                    PostFeedView()
                }
            }
        }
        .background(Color(white: 0.98))
    }
}

// MARK: - Subview Placeholders

struct StoriesView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                // Example Story
                VStack {
                    Circle()
                        .strokeBorder(LinearGradient(colors: [.orange, .pink], startPoint: .top, endPoint: .bottom), lineWidth: 3)
                        .frame(width: 65, height: 65)
                        .overlay(Image(systemName: "person.fill").foregroundColor(.gray))
                    Text("Tu historia").font(.caption2)
                }
                
                ForEach(0..<5) { _ in
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 65, height: 65)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PostFeedView: View {
    var body: some View {
        VStack(spacing: 15) {
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(height: 300)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
    }
}

// MARK: - Preview
struct ComunidadView_Previews: PreviewProvider {
    static var previews: some View {
        ComunidadView()
    }
}
