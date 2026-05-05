import SwiftUI

// MARK: - AlertDialog Component
struct AlertDialogView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        if isPresented {
            ZStack {
                // AlertDialogOverlay
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Opcional: Cerrar al tocar fuera
                        // isPresented = false
                    }
                    .transition(.opacity)

                // AlertDialogContent
                VStack(spacing: 20) {
                    content
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 24)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
            .zIndex(50) // Asegura que esté por encima de todo
        }
    }
}

// MARK: - Subcomponentes Estilizados
struct AlertDialogHeader<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AlertDialogTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.primary)
    }
}

struct AlertDialogDescription: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(.secondary)
    }
}

struct AlertDialogFooter<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    
    var body: some View {
        HStack(spacing: 12) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
