import SwiftUI

struct QuestionnaireView: View {
    var body: some View {
        VStack {
            // Main Card Container
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 15) {
                    
                    // Icon Container (bg-white/70)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        // Title
                        Text("Cuestionario de Seguimiento")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        // Description
                        Text("Ayuda a tu IA a predecir tus picos de estrés. Basado en investigación científica validada.")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineSpacing(2)
                        
                        // Reference Link
                        Link(destination: URL(string: "https://pmc.ncbi.nlm.nih.gov/articles/PMC7359652/")!) {
                            HStack(spacing: 4) {
                                Text("Ver estudio de referencia")
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.system(size: 10))
                            .foregroundColor(.orange.opacity(0.8))
                        }
                        .padding(.top, 2)
                        
                        // Action Button
                        Button(action: {
                            // Action to open questionnaire
                        }) {
                            Text("Responder Cuestionario")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                                .background(
                                    LinearGradient(
                                        colors: [Color.orange.opacity(0.8), Color.green.opacity(0.6)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Color.orange.opacity(0.05), Color.green.opacity(0.05)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.orange.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
}

// MARK: - Preview
struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(white: 0.98).edgesIgnoringSafeArea(.all)
            QuestionnaireView()
        }
    }
}
