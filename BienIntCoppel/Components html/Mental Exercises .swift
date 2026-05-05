import SwiftUI

struct MentalExercise: Identifiable {
    let id = UUID()
    let title: String
    let benefit: String
    let icon: String
    let colors: [Color]
    let iconColor: Color
    let duration: String
    let description: String
}

struct MentalExercisesView: View {
    // Data mapping from your React component
    private let exercises = [
        MentalExercise(
            title: "Meditación Guiada",
            benefit: "Reduce la ansiedad en 5 minutos",
            icon: "laurel.leading",
            colors: [Color(red: 0.95, green: 0.93, blue: 1.0), Color(red: 0.98, green: 0.98, blue: 1.0)],
            iconColor: .purple,
            duration: "5 min",
            description: "hola"
        ),
        MentalExercise(
            title: "Técnicas de Respiración",
            benefit: "Calma instantánea con respiración 4-7-8",
            icon: "wind",
            colors: [Color(red: 0.92, green: 0.96, blue: 1.0), Color(red: 0.98, green: 0.99, blue: 1.0)],
            iconColor: .blue,
            duration: "3 min",
            description: "hola"
        ),
        MentalExercise(
            title: "Mindfulness Laboral",
            benefit: "Mejora tu enfoque y productividad",
            icon: "headphones",
            colors: [Color(red: 0.90, green: 0.98, blue: 0.94), Color(red: 0.97, green: 1.0, blue: 0.98)],
            iconColor: .green,
            duration: "10 min",
            description: "hola"
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ejercicios de Cuidado Mental")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(Array(exercises.enumerated()), id: \.element.id) { index, ex in
                    ExerciseRow(exercise: ex)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 16)
    }
}

struct ExerciseRow: View {
    let exercise: MentalExercise
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon Container
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(exercise.iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: exercise.icon)
                    .font(.system(size: 18))
                    .foregroundColor(exercise.iconColor)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(exercise.benefit)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(exercise.duration)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.7))
            }
            
            Spacer()
            
            // Play Button
            Button(action: {
                // Start exercise action
            }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
        }
        .padding(16)
        .background(
            LinearGradient(colors: exercise.colors, startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct MentalExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(white: 0.98).edgesIgnoringSafeArea(.all)
            MentalExercisesView()
        }
    }
}
