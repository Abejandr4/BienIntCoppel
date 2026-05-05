import SwiftUI

// MARK: - Card Main Container
struct Card<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        // Use a background style that adapts to the environment
        .background(
            RoundedRectangle(cornerRadius: 12)
                .background(Material.regular) // Provides a native blurred/adaptive look
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                // Use primary/secondary with low opacity to mimic 'separator'
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Card Header
struct CardHeader<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) { // space-y-1.5
            content
        }
        .padding(24) // p-6
    }
}

// MARK: - Card Title
struct CardTitle: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .semibold)) // font-semibold
            .tracking(-0.5) // tracking-tight
            .foregroundColor(.primary)
    }
}

// MARK: - Card Description
struct CardDescription: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.subheadline) // text-sm
            .foregroundColor(.secondary) // text-muted-foreground
    }
}

// MARK: - Card Content
struct CardContent<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding([.horizontal, .bottom], 24) // p-6 pt-0
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Card Footer
struct CardFooter<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
        }
        .padding([.horizontal, .bottom], 24) // p-6 pt-0
    }
}

// MARK: - Preview Usage
struct Card_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(white: 0.98).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Card {
                    CardHeader {
                        CardTitle("Notificación de Bienestar")
                        CardDescription("Tienes un nuevo reto disponible.")
                    }
                    CardContent {
                        Text("Completa 10 minutos de meditación para ganar puntos adicionales en tu racha semanal.")
                            .font(.body)
                    }
                    CardFooter {
                        Button("Aceptar") { }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                        
                        Button("Más tarde") { }
                            .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
        }
    }
}
