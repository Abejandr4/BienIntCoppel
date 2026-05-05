import SwiftUI

// MARK: - Models

struct Post: Identifiable {
    let id = UUID()
    let user: CommunityUser
    let timeAgo: String
    let category: WellnessCategory
    let content: String
    let imageName: String?
    var likes: Int
    var comments: Int
    var isLiked: Bool = false
    var isSaved: Bool = false
}

struct CommunityUser: Identifiable {
    let id = UUID()
    let fullName: String
    let initials: String
    let avatarColor: Color
    let hasStory: Bool
    let avatarImage: String

    var firstName: String {
        fullName.components(separatedBy: " ").first ?? "Usuario"
    }
}

enum WellnessCategory: String, CaseIterable {
    case fisico    = "Físico"
    case mental    = "Mental"
    case financiero = "Financiero"
    case social    = "Social"

    var color: Color {
        switch self {
        case .fisico:     return Color(red: 0.9, green: 0.4, blue: 0.0)
        case .mental:     return Color(red: 0.0, green: 0.6, blue: 0.2)
        case .financiero: return Color(red: 0.8, green: 0.6, blue: 0.0)
        case .social:     return Color(red: 0.0, green: 0.4, blue: 0.8)
        }
    }

    var bgColor: Color {
        switch self {
        case .fisico:     return Color(red: 1.0, green: 0.96, blue: 0.90)
        case .mental:     return Color(red: 0.92, green: 0.98, blue: 0.94)
        case .financiero: return Color(red: 1.0, green: 0.98, blue: 0.90)
        case .social:     return Color(red: 0.90, green: 0.95, blue: 1.0)
        }
    }

    var icon: String {
        switch self {
        case .fisico:     return "waveform.path.ecg"
        case .mental:     return "brain.head.profile"
        case .financiero: return "dollarsign.circle"
        case .social:     return "person.2"
        }
    }
}

// MARK: - Sample Data

let sampleUsers: [CommunityUser] = [
    CommunityUser(fullName: "Ana Rodríguez",  initials: "AR", avatarColor: Color(red: 0.98, green: 0.64, blue: 0.40), hasStory: true,  avatarImage: "avatar_ana"),
    CommunityUser(fullName: "Carlos Méndez",  initials: "CM", avatarColor: Color(red: 0.66, green: 0.91, blue: 0.80), hasStory: true,  avatarImage: "avatar_carlos"),
    CommunityUser(fullName: "Laura Jiménez",  initials: "LJ", avatarColor: Color(red: 0.80, green: 0.70, blue: 0.95), hasStory: false, avatarImage: "avatar_laura"),
    CommunityUser(fullName: "Diego Torres",   initials: "DT", avatarColor: Color(red: 0.99, green: 0.85, blue: 0.47), hasStory: true,  avatarImage: "avatar_diego"),
    CommunityUser(fullName: "Sofía Herrera",  initials: "SH", avatarColor: Color(red: 0.90, green: 0.95, blue: 1.0),  hasStory: false, avatarImage: "avatar_sofia"),
]

let samplePosts: [Post] = [
    Post(user: sampleUsers[0], timeAgo: "hace 2h", category: .fisico,
         content: "¡Completé mi primera semana de rutina matutina! 💪 30 minutos de cardio cada día. La constancia es la clave.",
         imageName: "fisico-ana", likes: 24, comments: 5),
    Post(user: sampleUsers[1], timeAgo: "hace 4h", category: .mental,
         content: "10 minutos de meditación guiada antes de la jornada laboral han cambiado completamente mi productividad. Lo recomiendo a todos 🧘‍♂️",
         imageName: "mental-carlos", likes: 41, comments: 12),
    Post(user: sampleUsers[3], timeAgo: "hace 6h", category: .financiero,
         content: "Logré ahorrar el 10% de mi quincena por tercer mes consecutivo. El presupuesto semanal realmente funciona 💛",
         imageName: nil, likes: 18, comments: 3),
    Post(user: sampleUsers[2], timeAgo: "hace 1d", category: .social,
         content: "Gracias a todos los que participaron en el reto de pasos del mes. ¡Somos un equipo increíble! 🏃‍♀️✨",
         imageName: "social-laura", likes: 67, comments: 20),
]

// MARK: - Main View

struct ComunidadView: View {
    @State private var posts: [Post] = samplePosts
    @State private var selectedFilter: WellnessCategory? = nil
    @State private var showNewPost = false

    var filteredPosts: [Post] {
        guard let filter = selectedFilter else { return posts }
        return posts.filter { $0.category == filter }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: Header
                ComunidadHeaderView(onNewPost: { showNewPost = true })

                // MARK: Stories
                StoriesRowView(users: sampleUsers)
                    .padding(.top, 16)

                // MARK: Filter Pills
                FilterPillsView(selected: $selectedFilter)
                    .padding(.top, 12)

                // MARK: Post Feed
                LazyVStack(spacing: 16) {
                    ForEach(filteredPosts.indices, id: \.self) { index in
                        PostCardView(post: $posts[index])
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color(white: 0.98))
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showNewPost) {
            NewPostSheet()
        }
    }
}

// MARK: - Header

struct ComunidadHeaderView: View {
    let onNewPost: () -> Void

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
                VStack(alignment: .leading, spacing: 4) {
                    Text("Comunidad")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(.white)
                    Text("Comparte tus logros de bienestar")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                Button(action: onNewPost) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                }
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 25)
        }
    }
}

// MARK: - Stories Row

struct StoriesRowView: View {
    let users: [CommunityUser]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                // My Story
                MyStoryBubble()

                // Other users
                ForEach(users) { user in
                    UserStoryBubble(user: user)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}

struct MyStoryBubble: View {
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .strokeBorder(
                        LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 2.5
                    )
                    .frame(width: 66, height: 66)

                Circle()
                    .fill(Color(red: 0.95, green: 0.93, blue: 0.98))
                    .frame(width: 59, height: 59)
                    .overlay(
                        Text("VG")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(Color(red: 0.98, green: 0.64, blue: 0.40))
                    )

                // Plus badge
                Circle()
                    .fill(Color(red: 0.98, green: 0.64, blue: 0.40))
                    .frame(width: 20, height: 20)
                    .overlay(Image(systemName: "plus").font(.system(size: 10, weight: .bold)).foregroundColor(.white))
                    .offset(x: 22, y: 22)
            }

            Text("Tu historia")
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(Color(red: 90/255, green: 90/255, blue: 90/255))
        }
    }
}

struct UserStoryBubble: View {
    let user: CommunityUser

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                if user.hasStory {
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color(red: 0.98, green: 0.64, blue: 0.40), Color(red: 0.66, green: 0.91, blue: 0.80)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .frame(width: 66, height: 66)
                } else {
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.25), lineWidth: 2)
                        .frame(width: 66, height: 66)
                }

                Image(user.avatarImage)  // ← reemplaza el Circle con iniciales por esto
                    .resizable()
                    .scaledToFill()
                    .frame(width: 59, height: 59)
                    .clipShape(Circle())
            }
            
            
            Text(user.firstName)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(Color(red: 90/255, green: 90/255, blue: 90/255))
                .lineLimit(1)
        }
        .frame(width: 70)
    }
}

// MARK: - Filter Pills

struct FilterPillsView: View {
    @Binding var selected: WellnessCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(title: "Todos", icon: "square.grid.2x2", color: Color(red: 43/255, green: 43/255, blue: 43/255), isSelected: selected == nil) {
                    selected = nil
                }
                ForEach(WellnessCategory.allCases, id: \.self) { cat in
                    FilterPill(title: cat.rawValue, icon: cat.icon, color: cat.color, isSelected: selected == cat) {
                        selected = selected == cat ? nil : cat
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct FilterPill: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 12))
            }
            .foregroundColor(isSelected ? .white : color)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? color : color.opacity(0.1))
            )
        }
    }
}

// MARK: - Post Card

struct PostCardView: View {
    @Binding var post: Post
    @State private var animateLike = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header row
            HStack(spacing: 10) {
                // Avatar
                Circle()
                    .fill(post.user.avatarColor.opacity(0.3))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Text(post.user.initials)
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(post.user.avatarColor)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(post.user.fullName)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Color(red: 43/255, green: 43/255, blue: 43/255))
                    Text(post.timeAgo)
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(.gray)
                }

                Spacer()

                // Category badge
                HStack(spacing: 4) {
                    Image(systemName: post.category.icon)
                        .font(.system(size: 9, weight: .semibold))
                    Text(post.category.rawValue)
                        .font(.custom("Poppins-SemiBold", size: 10))
                }
                .foregroundColor(post.category.color)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(post.category.bgColor))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Content
            Text(post.content)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(Color(red: 60/255, green: 60/255, blue: 60/255))
                .lineSpacing(4)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 14)
            if let imageName = post.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .padding(.bottom, 14)
            }
            
            // Divider
            Divider()
                .padding(.horizontal, 16)

            // Action row
            HStack(spacing: 0) {
                // Like
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        animateLike = true
                        post.isLiked.toggle()
                        post.likes += post.isLiked ? 1 : -1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { animateLike = false }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 15))
                            .foregroundColor(post.isLiked ? .red : .gray)
                            .scaleEffect(animateLike ? 1.3 : 1.0)
                        Text("\(post.likes)")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }

                // Comment
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        Text("\(post.comments)")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }

                // Share
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "paperplane")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        Text("Compartir")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }

                // Save
                Button(action: { post.isSaved.toggle() }) {
                    Image(systemName: post.isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 15))
                        .foregroundColor(post.isSaved ? Color(red: 0.98, green: 0.64, blue: 0.40) : .gray)
                        .frame(width: 44)
                        .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 8)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

// MARK: - New Post Sheet

struct NewPostSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var postText = ""
    @State private var selectedCategory: WellnessCategory = .fisico
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceDialog = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                // Category picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Categoría")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Color(red: 43/255, green: 43/255, blue: 43/255))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(WellnessCategory.allCases, id: \.self) { cat in
                                FilterPill(title: cat.rawValue, icon: cat.icon, color: cat.color, isSelected: selectedCategory == cat) {
                                    selectedCategory = cat
                                }
                            }
                        }
                    }
                }

                // Photo picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Foto")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Color(red: 43/255, green: 43/255, blue: 43/255))

                    if let image = selectedImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .clipped()
                                .cornerRadius(14)

                            Button(action: { selectedImage = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                            }
                            .padding(8)
                        }
                    } else {
                        Button(action: { showSourceDialog = true }) {
                            VStack(spacing: 10) {
                                Image(systemName: "camera")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color(red: 0.98, green: 0.64, blue: 0.40))
                                Text("Agregar foto")
                                    .font(.custom("Poppins-Medium", size: 13))
                                    .foregroundColor(Color(red: 0.98, green: 0.64, blue: 0.40))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 110)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                                    .foregroundColor(Color(red: 0.98, green: 0.64, blue: 0.40).opacity(0.5))
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(red: 1.0, green: 0.96, blue: 0.90))
                            )
                        }
                    }
                }
                
                
                // Text editor
                VStack(alignment: .leading, spacing: 8) {
                    Text("¿Qué quieres compartir?")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Color(red: 43/255, green: 43/255, blue: 43/255))

                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(white: 0.97))
                            .frame(minHeight: 140)

                        TextEditor(text: $postText)
                            .font(.custom("Poppins-Regular", size: 14))
                            .padding(10)
                            .background(Color.clear)
                            .frame(minHeight: 140)

                        if postText.isEmpty {
                            Text("Comparte un logro, tip o reflexión sobre tu bienestar...")
                                .font(.custom("Poppins-Regular", size: 13))
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(16)
                        }
                    }
                }

                Spacer()

                // Post button
                Button(action: { dismiss() }) {
                    Text("Publicar")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.98, green: 0.64, blue: 0.40), Color(red: 0.99, green: 0.75, blue: 0.30)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                .disabled(postText.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(postText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
            }
            .padding(20)
            .navigationTitle("Nueva publicación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            .confirmationDialog("Seleccionar foto", isPresented: $showSourceDialog) {
                Button("Cámara") {
                    imageSource = .camera
                    showImagePicker = true
                }
                Button("Galería de fotos") {
                    imageSource = .photoLibrary
                    showImagePicker = true
                }
                Button("Cancelar", role: .cancel) {}
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(sourceType: imageSource, selectedImage: $selectedImage)
            }
        }
    }
    
    struct ImagePickerView: UIViewControllerRepresentable {
        var sourceType: UIImagePickerController.SourceType
        @Binding var selectedImage: UIImage?
        @Environment(\.dismiss) var dismiss

        func makeCoordinator() -> Coordinator { Coordinator(self) }

        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePickerView
            init(_ parent: ImagePickerView) { self.parent = parent }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                parent.selectedImage = info[.originalImage] as? UIImage
                parent.dismiss()
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.dismiss()
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
