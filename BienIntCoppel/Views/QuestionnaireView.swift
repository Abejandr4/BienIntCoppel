import SwiftUI
import FoundationModels

struct QuestionnaireView: View {
    
    @StateObject private var store = QuestionnaireStore()
    @StateObject private var vm: QuestionnaireViewModel
    @EnvironmentObject var appState: AppState
    @State private var showContactsView = false
    @State private var isHeaderVisible = true
    @State private var activeRecommendations: [WellnessRecommendation] = []
    @State private var showRecommendationBanner = false
    
  
    @ScaledMetric private var baseFontSize: CGFloat = 14
    @ScaledMetric private var smallFontSize: CGFloat = 12
    @ScaledMetric private var iconSize: CGFloat = 16
    @ScaledMetric private var cardPadding: CGFloat = 20
    
    init() {
        let s = QuestionnaireStore()
        _store = StateObject(wrappedValue: s)
        _vm = StateObject(wrappedValue: QuestionnaireViewModel(store: s))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    if isHeaderVisible {
                        headerCard
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    if vm.isLoading {
                        loadingCard
                    } else {
                        ForEach(vm.activeQuestions) { question in
                            questionCard(for: question)
                        }
                        submitButton
                    }
                    
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.callout)
                            .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                            .padding(.horizontal)
                            .accessibilityLabel("Error: \(error)")
                    }
                }
                .animation(.spring(), value: isHeaderVisible)
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .background(Color(white: 0.97).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showContactsView) {
                ContactosView()
            }
        }
        .onAppear {
            store.onEntrySaved = { entries in
                appState.update(from: entries)
            }
        }
    }
    
    // MARK: - Selection handler
    
    private func handleSelection(question: BurnoutQuestion, index: Int, text: String) {
        vm.selectedOptions[question.id] = (index: index, text: text)
        
        let weight = question.riskWeights?[safe: index] ?? 0
        let recs = WellnessRecommendations.recommendations(
            for: question.dimension,
            riskWeight: weight
        )
        
        if !recs.isEmpty {
            activeRecommendations = recs
            withAnimation(.spring(response: 0.4)) {
                showRecommendationBanner = true
            }
        } else {
            withAnimation(.spring(response: 0.3)) {
                showRecommendationBanner = false
            }
        }
    }
    
    // MARK: - Question card
    
    @ViewBuilder
    private func questionCard(for question: BurnoutQuestion) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            dimensionBadge(question.dimension)
            Text(question.text)
                .font(.system(size: baseFontSize, weight: .semibold, design: .rounded))
                // Alto contraste: casi negro sobre fondo claro
                .foregroundColor(Color(white: 0.12))
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            inputView(for: question)
            if showRecommendationBanner && !activeRecommendations.isEmpty {
                recommendationBanner
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(cardPadding)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        // Agrupa la card como una unidad para VoiceOver
        .accessibilityElement(children: .contain)
    }
    
    @ViewBuilder
    private func inputView(for question: BurnoutQuestion) -> some View {
        switch question.type {
        case .openText:
            openTextInput(for: question)
        case .multipleChoiceText:
            multipleChoiceList(for: question, emojiStyle: false)
        case .multipleChoiceEmoji:
            multipleChoiceList(for: question, emojiStyle: true)
        case .emojiOnly:
            emojiOnlyPicker(for: question)
        }
    }
    
    // MARK: - Input types
    
    @ViewBuilder
    private func openTextInput(for question: BurnoutQuestion) -> some View {
        let binding = Binding(
            get: { vm.textAnswers[question.id] ?? "" },
            set: { vm.textAnswers[question.id] = $0 }
        )
        ZStack(alignment: .topLeading) {
            if (vm.textAnswers[question.id] ?? "").isEmpty {
                Text("Escribe aquí...")
                    .font(.system(size: smallFontSize + 1))
                    // Suficiente contraste para placeholder: ratio ~4.6:1
                    .foregroundColor(Color(white: 0.45))
                    .padding(EdgeInsets(top: 10, leading: 6, bottom: 0, trailing: 0))
                    .accessibilityHidden(true)
            }
            TextEditor(text: binding)
                .font(.system(size: smallFontSize + 1, design: .rounded))
                .foregroundColor(Color(white: 0.12))
                .frame(minHeight: 90)
                .scrollContentBackground(.hidden)
                .accessibilityLabel(question.text)
                .accessibilityHint("Campo de texto libre")
        }
        .padding(10)
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                // Borde más visible: gris 50% en lugar de 20%
                .stroke(Color(white: 0.5).opacity(0.4), lineWidth: 1.5)
        )
    }
    
    @ViewBuilder
    private func multipleChoiceList(for question: BurnoutQuestion,
                                    emojiStyle: Bool) -> some View {
        VStack(spacing: emojiStyle ? 8 : 10) {
            ForEach(Array((question.options ?? []).enumerated()), id: \.offset) { index, option in
                let isSelected = vm.selectedOptions[question.id]?.index == index
                
                Button {
                    handleSelection(question: question, index: index, text: option)
                } label: {
                    HStack(spacing: emojiStyle ? 12 : 10) {
                        if emojiStyle {
                            Text(option)
                                .font(.system(size: baseFontSize))
                                .foregroundColor(Color(white: 0.12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Image(systemName: isSelected
                                  ? "checkmark.circle.fill" : "circle")
                                // Naranja oscuro para contraste suficiente sobre blanco
                                .foregroundColor(isSelected
                                    ? Color(red: 0.75, green: 0.35, blue: 0.0)
                                    : Color(white: 0.45))
                                .font(.system(size: iconSize))
                            Text(option)
                                .font(.system(size: smallFontSize + 1, design: .rounded))
                                .foregroundColor(Color(white: 0.12))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(emojiStyle ? 10 : 12)
                    // Altura mínima de toque: 44pt recomendado por Apple HIG
                    .frame(minHeight: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected
                                  ? Color(red: 1.0, green: 0.92, blue: 0.80)
                                  : Color.white.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected
                                    ? Color(red: 0.75, green: 0.35, blue: 0.0).opacity(0.6)
                                    : Color(white: 0.5).opacity(0.25), lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(option)
                .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                .accessibilityHint(isSelected ? "Seleccionado" : "Toca para seleccionar")
            }
        }
    }
    
    @ViewBuilder
    private func emojiOnlyPicker(for question: BurnoutQuestion) -> some View {
        HStack(spacing: 8) {
            ForEach(Array((question.options ?? []).enumerated()), id: \.offset) { index, emoji in
                let isSelected = vm.selectedOptions[question.id]?.index == index
                
                Button {
                    handleSelection(question: question, index: index, text: emoji)
                } label: {
                    Text(emoji)
                        // Emoji más grande para facilitar el toque
                        .font(.system(size: 34))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 54)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isSelected
                                      ? Color(red: 1.0, green: 0.92, blue: 0.80)
                                      : Color.white.opacity(0.7))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isSelected
                                        ? Color(red: 0.75, green: 0.35, blue: 0.0).opacity(0.6)
                                        : Color.clear, lineWidth: 2)
                        )
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.25), value: isSelected)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Opción \(index + 1): \(emoji)")
                .accessibilityAddTraits(isSelected ? [.isSelected] : [])
            }
        }
    }
    
    // MARK: - Dimension badge
    
    private func dimensionBadge(_ dimension: BurnoutDimension) -> some View {
        let (label, color, icon) = dimensionStyle(dimension)
        return HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: smallFontSize - 2))
            Text(label)
                .font(.system(size: smallFontSize - 1, weight: .semibold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
        .accessibilityLabel("Dimensión: \(label)")
    }
    
    private func dimensionStyle(_ d: BurnoutDimension) -> (String, Color, String) {
        switch d {
        // Colores ajustados para contraste suficiente sobre sus fondos claros
        case .cargaLaboral:         return ("Carga laboral",
                                            Color(red: 0.75, green: 0.35, blue: 0.0), "briefcase")
        case .agotamientoEmocional: return ("Agotamiento",
                                            Color(red: 0.75, green: 0.1,  blue: 0.1), "battery.25")
        case .despersonalizacion:   return ("Trato al cliente",
                                            Color(red: 0.45, green: 0.1,  blue: 0.65), "person.2")
        case .realizacionPersonal:  return ("Realización personal",
                                            Color(red: 0.1,  green: 0.5,  blue: 0.15), "star")
        case .indicadoresFisicos:   return ("Señales físicas",
                                            Color(red: 0.05, green: 0.35, blue: 0.7),  "heart.text.clipboard")
        }
    }
    
    // MARK: - Cards
    
    private var recommendationBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: smallFontSize - 1))
                    .foregroundColor(Color(red: 0.75, green: 0.35, blue: 0.0))
                Text("Un pequeño paso puede ayudar")
                    .font(.system(size: smallFontSize, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.75, green: 0.35, blue: 0.0))
            }
            ForEach(activeRecommendations.prefix(2), id: \.text) { rec in
                HStack(alignment: .top, spacing: 8) {
                    Text(rec.icon)
                        .font(.system(size: baseFontSize))
                        .accessibilityHidden(true)
                    Text(rec.text)
                        .font(.system(size: smallFontSize, design: .rounded))
                        // Alto contraste: gris oscuro en lugar de .secondary
                        .foregroundColor(Color(white: 0.25))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(3)
                }
            }
        }
        .padding(14)
        .background(Color(red: 1.0, green: 0.95, blue: 0.87))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 0.75, green: 0.35, blue: 0.0).opacity(0.3), lineWidth: 1.5)
        )
        .accessibilityElement(children: .combine)
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 40, height: 40)
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.75, green: 0.35, blue: 0.0))
                }
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Cuestionario de Seguimiento")
                        .fontWeight(.bold)
                        .foregroundColor(Color(white: 0.12))
                    Text("Responde con honestidad para un mejor resultado. La empresa no puede acceder a tus respuestas.")
                        .foregroundColor(Color(white: 0.3))
                        .lineSpacing(2)
                        .padding(.trailing, 20)
                    
                }
                Spacer()
                Button(action: { isHeaderVisible = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(white: 0.4))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color(white: 0.0).opacity(0.06)))
                }
                .accessibilityLabel("Cerrar aviso")
            }
        }
        .padding(cardPadding)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var submitButton: some View {
        Button {
            Task { await vm.submitAndGenerate() }
        } label: {
            Group {
                if vm.isSaved {
                    Label("¡Guardado!", systemImage: "checkmark.seal")
                } else {
                    Text("Enviar respuestas")
                }
            }
            .font(.system(size: baseFontSize + 1, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                vm.canSubmit
                ? LinearGradient(
                    colors: [Color(red: 0.75, green: 0.35, blue: 0.0),
                             Color(red: 0.7,  green: 0.2,  blue: 0.35)],
                    startPoint: .leading, endPoint: .trailing)
                : LinearGradient(
                    colors: [Color(white: 0.75), Color(white: 0.70)],
                    startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!vm.canSubmit)
        .accessibilityLabel(vm.isSaved ? "Respuestas guardadas" : "Enviar respuestas")
        .accessibilityHint(vm.canSubmit ? "" : "Responde al menos una pregunta para continuar")
    }
    
    private var loadingCard: some View {
        VStack(spacing: 14) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Color(red: 0.75, green: 0.35, blue: 0.0))
            Text("Personalizando tus siguientes preguntas...")
                .font(.system(size: smallFontSize + 1, design: .rounded))
                .foregroundColor(Color(white: 0.3))
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .accessibilityLabel("Cargando nuevas preguntas")
    }
    
    private var cardBackground: some ShapeStyle {
        LinearGradient(
            colors: [Color(red: 1.0, green: 0.97, blue: 0.93),
                     Color(red: 0.96, green: 0.99, blue: 0.96)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    QuestionnaireView()
        .environmentObject(AppState())
}
