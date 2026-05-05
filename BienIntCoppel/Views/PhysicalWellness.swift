import SwiftUI

// MARK: - Data Models
struct ActivityStat: Identifiable {
    let id = UUID()
    let label: String
    let value: String
    let iconName: String
}

struct TrainingStat: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

struct QuickAccessItem: Identifiable {
    let id = UUID()
    let title: String
    let desc: String
    let iconName: String
    let color: Color
    let bgColor: Color
}

struct ChallengeItem: Identifiable {
    let id = UUID()
    let title: String
    let desc: String
    let iconName: String // Cambiado de emoji a iconName
}

// MARK: - Main View
struct PhysicalWellnessView: View {
    
    // MARK: - Computed Properties
    private var nutritionPlanAttributedText: AttributedString {
        var result = AttributedString()
        
        var part1 = AttributedString("Te invitamos a complementar tu atención, agendando una Teleconsulta Nutricional a través de ")
        part1.foregroundColor = .secondary
        
        var part2 = AttributedString("www.coppelcontigo.com")
        part2.foregroundColor = .green
        part2.underlineStyle = .single
        
        var part3 = AttributedString(" con alguno de los nutriólogos expertos que tenemos disponibles para ti o llamando a la línea Coppel Contigo ")
        part3.foregroundColor = .secondary
        
        var part4 = AttributedString("800 020 4050")
        part4.foregroundColor = .green
        part4.underlineStyle = .single
        
        var part5 = AttributedString(" > Plan Salud > 2 > Opción 4.")
        part5.foregroundColor = .secondary
        
        result.append(part1)
        result.append(part2)
        result.append(part3)
        result.append(part4)
        result.append(part5)
        
        return result
    }
    
    // MARK: - Data
    private let activityStats = [
        ActivityStat(label: "Tiempo", value: "36 Min", iconName: "clock"),
        ActivityStat(label: "Distancia", value: "0.00 Km", iconName: "mappin.and.ellipse"),
        ActivityStat(label: "Pasos", value: "2,053", iconName: "shoeprints.fill")
    ]
    
    private let trainingStats = [
        TrainingStat(label: "Cantidad", value: "13 Veces"),
        TrainingStat(label: "Tiempo", value: "635 Min"),
        TrainingStat(label: "Distancia", value: "99.64 Km"),
        TrainingStat(label: "Pasos", value: "0")
    ]
    
    private let quickAccess = [
        QuickAccessItem(title: "Tu actividad", desc: "Visualiza tu historial de entrenamientos y objetivos cumplidos.", iconName: "dumbbell.fill", color: .orange, bgColor: .orange.opacity(0.15)),
        QuickAccessItem(title: "Peso y altura", desc: "Registra tu peso y altura para el cálculo de calorías.", iconName: "scalemass.fill", color: .green, bgColor: .green.opacity(0.15)),
        QuickAccessItem(title: "Coppel Contigo", desc: "Orientación telefónica especializada, ocupas ambulancia o algún apoyo económico.", iconName: "heart.fill", color: .orange, bgColor: .orange.opacity(0.15)),
        QuickAccessItem(title: "Llamar a Coppel Contigo", desc: "Orientación telefónica especializada, ocupas ambulancia o algún apoyo económico.", iconName: "phone.fill", color: .green, bgColor: .green.opacity(0.15))
    ]
    
    // Cambiamos los emojis por SF Symbols acordes a cada reto
    private let challenges = [
        ChallengeItem(title: "Entrenamientos 2026", desc: "Todos los entrenamientos 2026", iconName: "figure.run"),
        ChallengeItem(title: "Actívate 10,000 pasos", desc: "Realizar 10,000 pasos al día durante un mes.", iconName: "figure.walk"),
        ChallengeItem(title: "Reto de Actividad Física 2026", desc: "¡Actívate y súmate al reto!", iconName: "bolt.fill"),
        ChallengeItem(title: "Camina tu maratón 2026", desc: "Camina, corre o usa la caminadora. Recorre de manera individual 42,195 metros.", iconName: "medal.fill"),
        ChallengeItem(title: "Reto Actívate en Familia 2026", desc: "El colaborador deberán realizar una rutina de ejercicios: 10 minutos de calentamiento, 10 minutos aeróbico y 10 minutos de fuerza.", iconName: "person.3.fill")
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    
                    VStack(spacing: 24) {
                        activityTodaySection
                        trainingsSection
                        nutritionPlanSection
                        quickAccessSection
                        challengesSection
                        echaleKilosBanner
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 12) {
                
                
                HStack {
                    Image(systemName: "waveform.path.ecg")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                    VStack(alignment: .leading) {
                        Text("Bienestar Físico")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Tu actividad y salud")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                Spacer()
            }
            .padding(.top, 80)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 24)
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 24, bottomTrailingRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.orange, .yellow, .green],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(0.9)
        )
    }
    
    private var activityTodaySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tu actividad hoy")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                ForEach(activityStats) { stat in
                    Spacer()
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color.orange.opacity(0.4), lineWidth: 2)
                                .background(Circle().fill(Color.orange.opacity(0.1)))
                                .frame(width: 48, height: 48)
                            Image(systemName: stat.iconName)
                                .foregroundColor(.orange)
                                .font(.system(size: 20))
                        }
                        Text(stat.value)
                            .font(.system(size: 16, weight: .bold))
                        Text(stat.label)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 20)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var trainingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tus Entrenamientos")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("(13)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            HStack {
                ForEach(trainingStats) { stat in
                    VStack(spacing: 4) {
                        Text(stat.value)
                            .font(.system(size: 14, weight: .bold))
                        Text(stat.label)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 20)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var nutritionPlanSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Plan de Alimentación")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(nutritionPlanAttributedText)
                    .font(.subheadline)
                    .lineSpacing(4)
                
                Text("Solicita tu plan personalizado.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Button(action: {}) {
                    Text("Solicitar plan")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Accesos rápidos")
                .font(.headline)
                .fontWeight(.bold)
            
            ForEach(quickAccess) { item in
                Button(action: {}) {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(item.bgColor)
                                .frame(width: 48, height: 48)
                            Image(systemName: item.iconName)
                                .foregroundColor(item.color)
                                .font(.system(size: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text(item.desc)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(16)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
            }
        }
    }
    
    private var challengesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Retos")
                .font(.headline)
                .fontWeight(.bold)
            
            ForEach(challenges) { item in
                Button(action: {}) {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.1))
                                .frame(width: 48, height: 48)
                            
                            // Usamos Image con el SF Symbol en lugar de Text con el emoji
                            Image(systemName: item.iconName)
                                .foregroundColor(.orange)
                                .font(.system(size: 24))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            Text(item.desc)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(16)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
            }
        }
    }
    
    private var echaleKilosBanner: some View {
            GeometryReader { geometry in
                
                // Definimos los colores institucionales de Coppel
                let coppelBlue = Color(red: 0 / 255, green: 93 / 255, blue: 170 / 255)
                let coppelLightBlue = Color(red: 0 / 255, green: 125 / 255, blue: 205 / 255)
                
                ZStack {
                    // Fondo con el degradado del azul Coppel
                    LinearGradient(
                        colors: [coppelLightBlue, coppelBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ÉCHALE LOS KILOS ••• COPPEL")
                            .font(.system(size: 10, weight: .medium, design: .default))
                            .tracking(1.5)
                            .foregroundColor(.white.opacity(0.8))
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("¡El poder")
                            Text("está en ti!")
                                .foregroundColor(.yellow)
                        }
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        
                        Text("Inscríbete hoy al programa **Échale los Kilos** y da el primer paso.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                            .frame(maxWidth: 200, alignment: .leading)
                        
                        Button(action: {}) {
                            Text("¿Te atreves?")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                // Usamos el azul fuerte para el botón para que contraste
                                .background(coppelBlue.opacity(0.8))
                                .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
                                .clipShape(Capsule())
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .cornerRadius(16)
            }
            .frame(height: 176)
        }
}

// MARK: - Preview
#Preview {
    PhysicalWellnessView()
}
