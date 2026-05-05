import SwiftUI

// 1. Definimos las variantes (Equivalente a alertVariants)
enum AlertVariant {
    case `default`
    case destructive
    
    var backgroundColor: Color {
        switch self {
        case .default: return Color(.systemBackground)
        case .destructive: return Color.red.opacity(0.1)
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .default: return .primary
        case .destructive: return .red
        }
    }
    
    var borderColor: Color {
        switch self {
        case .default: return Color(.separator)
        case .destructive: return .red.opacity(0.5)
        }
    }
}

// 2. Componente Principal (Alert)
struct AlertView<Content: View>: View {
    let variant: AlertVariant
    let icon: Image?
    let content: Content
    
    init(
        variant: AlertVariant = .default,
        icon: Image? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let icon = icon {
                icon
                    .font(.system(size: 16))
                    .foregroundColor(variant.foregroundColor)
                    .padding(.top, 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                content
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(variant.backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(variant.borderColor, lineWidth: 1)
        )
    }
}

// 3. Sub-componentes (Equivalentes a AlertTitle y AlertDescription)
struct AlertTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .lineSpacing(1)
    }
}

struct AlertDescription: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(.secondary)
            .lineSpacing(4)
    }
}
