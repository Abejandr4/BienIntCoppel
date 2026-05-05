import SwiftUI

struct MentalExercisesView: View {

    @State private var expandida: String? = nil

    private let categorias: [(nombre: String, icono: String, color: Color, ejercicios: [MentalExercise])] = [
        ("Respiración",  "wind",                ExercisesData.respiracion.first?.iconColor ?? .blue,   ExercisesData.respiracion),
        ("Mindfulness",  "brain.head.profile",  ExercisesData.mindfulness.first?.iconColor ?? .green,  ExercisesData.mindfulness),
        ("Somático",     "figure.flexibility",  ExercisesData.somatico.first?.iconColor    ?? .purple, ExercisesData.somatico),
        ("Escritura",    "square.and.pencil",   ExercisesData.escritura.first?.iconColor   ?? .orange, ExercisesData.escritura)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ejercicios de Cuidado Mental")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal)

            VStack(spacing: 10) {
                ForEach(categorias, id: \.nombre) { categoria in
                    CategoriaSection(
                        nombre:    categoria.nombre,
                        icono:     categoria.icono,
                        color:     categoria.color,
                        ejercicios: categoria.ejercicios,
                        expandida: $expandida
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 16)
    }
}

// MARK: - Sección por categoría
struct CategoriaSection: View {

    let nombre:     String
    let icono:      String
    let color:      Color
    let ejercicios: [MentalExercise]
    @Binding var expandida: String?

    private var estaExpandida: Bool { expandida == nombre }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Header desplegable
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expandida = estaExpandida ? nil : nombre
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: icono)
                            .font(.system(size: 16))
                            .foregroundColor(color)
                    }

                    Text(nombre)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)

                    Spacer()

                    Text("\(ejercicios.count) ejercicios")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)

                    Image(systemName: estaExpandida ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .animation(.spring(response: 0.35), value: estaExpandida)
                }
                .padding(14)
                .background(Color(.systemBackground))
                .cornerRadius(estaExpandida ? 0 : 16)
                .overlay(
                    RoundedRectangle(cornerRadius: estaExpandida ? 0 : 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())

            // MARK: Lista de ejercicios
            if estaExpandida {
                VStack(spacing: 1) {
                    ForEach(ejercicios) { ejercicio in
                        ExerciseRow(exercise: ejercicio)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .background(color.opacity(0.04))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(estaExpandida ? 0.3 : 0.2), lineWidth: 1)
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: estaExpandida)
    }
}

// MARK: - ExerciseRow
struct ExerciseRow: View {
    let exercise: MentalExercise
    @State private var mostrarDetalle = false

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(exercise.iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: exercise.icon)
                    .font(.system(size: 18))
                    .foregroundColor(exercise.iconColor)
            }

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

            Button(action: {
                UserInteractionTracker.shared.registrarClic(categoria: exercise.title)
                mostrarDetalle = true
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
        .padding(14)
        .background(
            LinearGradient(colors: exercise.colors, startPoint: .leading, endPoint: .trailing)
        )
        .sheet(isPresented: $mostrarDetalle) {
            ExerciseDetailSheet(exercise: exercise)
        }
    }
}

// MARK: - Sheet de detalle
struct ExerciseDetailSheet: View {
    let exercise: MentalExercise
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {

            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Ícono y título
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(exercise.iconColor.opacity(0.15))
                                .frame(width: 64, height: 64)
                            Image(systemName: exercise.icon)
                                .font(.system(size: 28))
                                .foregroundColor(exercise.iconColor)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            HStack(spacing: 6) {
                                Image(systemName: "clock")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Text(exercise.duration)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.top, 8)

                    // Beneficio
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Beneficio")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(exercise.iconColor)
                        Text(exercise.benefit)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(exercise.iconColor.opacity(0.08))
                    .cornerRadius(14)

                    // Descripción
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Cómo hacerlo")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.secondary)
                        Text(exercise.description)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                            .lineSpacing(6)
                    }

                    // Botón cerrar
                    Button(action: { dismiss() }) {
                        Text("Cerrar")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(exercise.iconColor)
                            .cornerRadius(14)
                    }
                    .padding(.top, 8)
                    Button(action: { dismiss() }) {
                        Text("Compartir")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(exercise.iconColor)
                            .cornerRadius(14)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}


// MARK: - Preview
struct MentalExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(white: 0.98).edgesIgnoringSafeArea(.all)
            ScrollView { MentalExercisesView() }
        }
    }
}
