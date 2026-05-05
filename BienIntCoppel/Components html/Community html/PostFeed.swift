import SwiftUI

struct Post: Identifiable {
    let id: Int
    let user: String
    let avatar: String
    let time: String
    let content: String
    let tag: String
    let tagColor: Color
    let tagTextColor: Color
    let likes: Int
    let comments: Int
    let image: String? // Optional since not all posts have images
}

struct PostFeed: View {
    // 1. Data Source
    let posts = [
        Post(id: 1, user: "Ana Ramírez", avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&h=80&fit=crop", time: "Hace 2 horas", content: "¡Terminé mi primera sesión de meditación guiada! Me siento mucho más tranquila. 🧘‍♀️", tag: "Meta Mental Cumplida", tagColor: Color.emerald.opacity(0.1), tagTextColor: .emerald, likes: 24, comments: 5, image: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=250&fit=crop"),
        Post(id: 2, user: "Carlos Mendoza", avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&h=80&fit=crop", time: "Hace 5 horas", content: "30 minutos de caminata durante el almuerzo. ¡Pequeños pasos hacen la diferencia! 💪", tag: "Entrenamiento Físico", tagColor: Color.orange.opacity(0.1), tagTextColor: .orange, likes: 18, comments: 3, image: nil),
        Post(id: 3, user: "María López", avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop", time: "Hace 1 día", content: "¡Logré ahorrar el 10% de mi quincena este mes! La planificación financiera funciona. 📊", tag: "Logro Financiero", tagColor: Color.yellow.opacity(0.1), tagTextColor: .orange, likes: 32, comments: 8, image: nil),
        Post(id: 4, user: "José Pérez", avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&h=80&fit=crop", time: "Hace 2 días", content: "Organizamos un torneo de futbol entre tiendas. ¡La mejor forma de hacer equipo! ⚽", tag: "Evento Social", tagColor: Color.blue.opacity(0.1), tagTextColor: .blue, likes: 45, comments: 12, image: nil)
    ]
    
    // 2. State for Likes
    @State private var likedPosts: [Int: Bool] = [:]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(posts) { post in
                    PostCard(
                        post: post,
                        isLiked: likedPosts[post.id, default: false],
                        onLike: {
                            likedPosts[post.id, default: false].toggle()
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

// 3. Individual Post Component
struct PostCard: View {
    let post: Post
    let isLiked: Bool
    let onLike: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: post.avatar)) { img in
                    img.resizable().aspectRatio(contentMode: .fill)
                } placeholder: { Color.gray.opacity(0.2) }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(post.user)
                        .font(.system(size: 14, weight: .semibold))
                    Text(post.time)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(post.tag)
                    .font(.system(size: 10, weight: .medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(post.tagColor)
                    .foregroundColor(post.tagTextColor)
                    .clipShape(Capsule())
            }
            .padding(16)
            
            // Text Content
            Text(post.content)
                .font(.system(size: 14))
                .lineSpacing(4)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            
            // Post Image (if exists)
            if let imageURL = post.image {
                AsyncImage(url: URL(string: imageURL)) { img in
                    img.resizable().aspectRatio(contentMode: .fill)
                } placeholder: { Color.gray.opacity(0.2) }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .clipped()
            }
            
            // Action Bar
            HStack(spacing: 24) {
                Button(action: onLike) {
                    HStack(spacing: 6) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .secondary)
                        Text("\(post.likes + (isLiked ? 1 : 0))")
                    }
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "message")
                    Text("\(post.comments)")
                }
                
                Image(systemName: "square.and.arrow.up")
                
                Spacer()
            }
            .font(.system(size: 12))
            .foregroundColor(.secondary)
            .padding(16)
            .border(Color.gray.opacity(0.1), width: 1) // Top border equivalent
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Custom Emerald color extension to match Tailwind
extension Color {
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}
