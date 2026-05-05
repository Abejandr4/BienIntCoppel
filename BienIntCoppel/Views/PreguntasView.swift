import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let q: String
    let a: String
}

struct PreguntasView: View {
    // FAQ Data from your React component
    private let faqItems = [
        FAQItem(q: "¿Cómo funciona el acompañamiento IA?", a: "Copelia analiza los patrones de estrés y recomienda acciones que te beneficiarían. Además, te recomienda actividades para bajar el estrés que te podrían gustar."),
        FAQItem(q: "¿Lo que conteste en la app es anónimo?", a: "Sí, todas tus respuestas son confidenciales y si se borra la aplicación, con ella esos datos."),
        FAQItem(q: "¿Cada cuánto debo responder el cuestionario?", a: "Recomendamos responder al menos una vez al día para obtener mejores recomendaciones."),
        FAQItem(q: "¿Cómo puedo ir con un profesional?", a: "Preguntaq en tu CEDIS más cercano o buscálo en nuestro directorio. Las citas se pueden realizar en persona o por teléfono.")
    ]
    
    @State private var expandedId: UUID? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - Header
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.22, green: 0.63, blue: 0.95), // sky-400
                            Color(red: 0.48, green: 0.81, blue: 0.95), // sky-300
                            Color(red: 0.66, green: 0.91, blue: 0.80)  // emerald-300
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.9)
                    .frame(height: 140)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Preguntas Frecuentes")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Resuelve tus dudas")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 25)
                }
                .edgesIgnoringSafeArea(.top)

                // MARK: - FAQ Section
                VStack(spacing: 12) {
                    ForEach(faqItems) { item in
                        FAQRow(item: item, isExpanded: expandedId == item.id) {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                if expandedId == item.id {
                                    expandedId = nil
                                } else {
                                    expandedId = item.id
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 25)

                // MARK: - Still have questions card
                VStack(spacing: 8) {
                    Image(systemName: "robot")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                        .padding(.bottom, 4)
                    
                    Text("¿Aún tienes dudas?")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    
                    Text("Pregunta directamente a tu Acompañante AI desde Home")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [Color.blue.opacity(0.05), Color.green.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.vertical, 30)
            }
        }
        .background(Color(white: 0.98))
    }
}

// MARK: - Accordion Row Component
struct FAQRow: View {
    let item: FAQItem
    let isExpanded: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    Text(item.q)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 45 : 0))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                
                if isExpanded {
                    Text(item.a)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct PreguntasView_Previews: PreviewProvider {
    static var previews: some View {
        PreguntasView()
    }
}
