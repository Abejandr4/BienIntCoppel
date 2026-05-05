import SwiftUI

// 1. Changed to a proper Struct naming convention (PascalCase)
struct RiskAlertBanner: View {
    // 2. Added EnvironmentObject or ObservedObject to access your store
    // Replace 'YourStoreClass' with your actual class name (e.g., BurnoutStore)
    @ObservedObject var store: QuestionnaireStore
    
    // 3. Added a state or binding for the navigation
    @Binding var showContactsView: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "heart.text.clipboard")
                    .font(.system(size: 22))
                    .foregroundColor(.pink)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Te recomendamos hablar con alguien")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    
                    // Accessing the message from your store
                    Text(store.riskLevel.mensaje)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Divider().opacity(0.4)
            
            Text("Un psicólogo puede ayudarte a procesar lo que estás viviendo. No tienes que cargarlo solo/a.")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .lineSpacing(3)
            
            Button {
                showContactsView = true
            } label: {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Ver contactos de apoyo")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.8), Color.purple.opacity(0.6)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.pink.opacity(0.06), Color.purple.opacity(0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.pink.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}


