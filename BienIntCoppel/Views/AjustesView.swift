import SwiftUI

struct AjustesView: View {
    // State variables to mimic your React useState hooks
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    // Mock user data based on your "¡Hola Vale!" header
    private let userName = "Vale"
    private let userEmail = "vale@coppel.com"
    private let version = "Coppel Bienestar v1.0"

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - Header Profile Section
                ZStack {
                    // Consistent Brand Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.98, green: 0.64, blue: 0.40), // orange-400
                            Color(red: 0.99, green: 0.75, blue: 0.35), // orange-300
                            Color(red: 0.66, green: 0.91, blue: 0.80)  // emerald-300
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.9)
                    
                    VStack(spacing: 12) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 85, height: 85)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.6), lineWidth: 3)
                                )
                            
                            Text("VG") // Hardcoded initials per previous design
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
                        
                        VStack(spacing: 4) {
                            Text(userName)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(userEmail)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                }
                .edgesIgnoringSafeArea(.top)

                // MARK: - Settings Groups
                VStack(spacing: 20) {
                    
                    // Group 1: General Settings
                    VStack(spacing: 0) {
                        SettingsRow(icon: "bell.fill", label: "Notificaciones", variant: .toggle($notificationsEnabled))
                        Divider().padding(.leading, 55)
                        SettingsRow(icon: "shield.fill", label: "Privacidad", variant: .arrow)
                        Divider().padding(.leading, 55)
                        SettingsRow(icon: "moon.fill", label: "Modo oscuro", variant: .toggle($darkModeEnabled))
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 25)

                    // MARK: - Logout Button
                    Button(action: {
                        // Handle logout logic
                    }) {
                        HStack(spacing: 15) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            
                            Text("Cerrar Sesión")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                }
                
                // Footer
                Text(version)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
            }
        }
        .background(Color(white: 0.98))

    }
}

// MARK: - Settings Components

enum SettingsVariant {
    case arrow
    case toggle(Binding<Bool>)
}

struct SettingsRow: View {
    let icon: String
    let label: String
    let variant: SettingsVariant
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon Container
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.96))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
            }
            
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            switch variant {
            case .arrow:
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(white: 0.8))
            case .toggle(let binding):
                Toggle("", isOn: binding)
                    .labelsHidden()
                    .tint(.orange) // Matches the app brand accent
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Preview
struct AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView()
    }
}
