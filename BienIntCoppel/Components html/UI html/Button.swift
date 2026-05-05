import SwiftUI

// MARK: - Button Variants
enum ButtonVariant {
    case primary, destructive, outline, secondary, ghost, link
}

enum ButtonSize {
    case `default`, sm, lg, icon
}

struct CustomButton<Content: View>: View {
    let variant: ButtonVariant
    let size: ButtonSize
    let action: () -> Void
    let content: () -> Content

    init(
        variant: ButtonVariant = .primary,
        size: ButtonSize = .default,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = variant
        self.size = size
        self.action = action
        self.content = content
    }

    var body: some View {
        Button(action: action) {
            content()
                .font(size == .sm ? .caption : .body)
                .fontWeight(.medium)
        }
        .buttonStyle(CustomButtonStyle(variant: variant, size: size))
    }
}

// MARK: - Button Styles (The "CVA" Logic)
struct CustomButtonStyle: ButtonStyle {
    let variant: ButtonVariant
    let size: ButtonSize

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, horizontalPadding)
            .frame(height: height)
            .frame(width: size == .icon ? height : nil)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: variant == .outline ? 1 : 0)
            )
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeIn(duration: 0.1), value: configuration.isPressed)
    }

    // MARK: - Layout Helpers
    private var height: CGFloat {
        switch size {
        case .sm: return 32
        case .lg: return 44
        case .icon: return 36
        default: return 38
        }
    }

    private var horizontalPadding: CGFloat {
        if size == .icon { return 0 }
        switch size {
        case .sm: return 12
        case .lg: return 32
        default: return 16
        }
    }

    // MARK: - Color Logic
    private func backgroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .primary: return .orange // Matches your Coppel brand color
        case .destructive: return .red
        case .secondary: return Color(white: 0.9)
        case .outline, .ghost, .link: return .clear
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary, .destructive: return .white
        case .outline, .ghost: return .primary
        case .secondary: return .black
        case .link: return .orange
        }
    }

    private var borderColor: Color {
        variant == .outline ? Color(white: 0.8) : .clear
    }
}

// MARK: - Usage Examples
struct Button_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CustomButton(variant: .primary) {
                print("Default tapped")
            } content: {
                Text("Default Button")
            }

            CustomButton(variant: .outline, size: .sm) { } content: {
                HStack {
                    Image(systemName: "plus")
                    Text("Outline SM")
                }
            }

            CustomButton(variant: .destructive, size: .lg) { } content: {
                Text("Destructive LG")
            }

            CustomButton(variant: .ghost, size: .icon) { } content: {
                Image(systemName: "trash")
            }
            
            CustomButton(variant: .link) { } content: {
                Text("Enlace de ayuda")
            }
        }
        .padding()
    }
}
