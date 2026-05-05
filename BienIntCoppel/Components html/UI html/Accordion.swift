import SwiftUI

struct AccordionItemView: View {
    let title: String
    let content: String
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            DisclosureGroup(isExpanded: $isExpanded) {
                // AccordionContent
                Text(content)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 16)
                    .foregroundColor(.secondary)
            } label: {
                // AccordionTrigger
                Text(title)
                    .font(.smSystemFont(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(.vertical, 16)
            }
            .accentColor(.secondary) // Color del ChevronDown
        }
        .border(width: 1, edges: [.bottom], color: Color(.separator))
    }
}

// Helper para el borde inferior (simula el "border-b" de Tailwind)
extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(
            EdgeBorder(width: width, edges: edges).foregroundColor(color)
        )
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat { rect.minX }
            var y: CGFloat { rect.minY }
            var w: CGFloat { rect.width }
            var h: CGFloat { rect.height }
            switch edge {
            case .top: path.addRect(CGRect(x: x, y: y, width: w, height: width))
            case .bottom: path.addRect(CGRect(x: x, y: y + h - width, width: w, height: width))
            case .leading: path.addRect(CGRect(x: x, y: y, width: width, height: h))
            case .trailing: path.addRect(CGRect(x: x + w - width, y: y, width: width, height: h))
            }
        }
        return path
    }
}
