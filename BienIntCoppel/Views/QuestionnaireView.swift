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
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
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
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            inputView(for: question)
            if showRecommendationBanner && !activeRecommendations.isEmpty {
                recommendationBanner
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // Extracted switch so the compiler can type-check each branch independently
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
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding(EdgeInsets(top: 10, leading: 6, bottom: 0, trailing: 0))
            }
            TextEditor(text: binding)
                .font(.system(size: 13, design: .rounded))
                .frame(minHeight: 90)
                .scrollContentBackground(.hidden)
        }
        .padding(10)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
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
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Image(systemName: isSelected
                                  ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isSelected ? .orange : .secondary)
                                .font(.system(size: 16))
                            Text(option)
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(emojiStyle ? 10 : 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected
                                  ? Color.orange.opacity(0.08)
                                  : Color.white.opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected
                                    ? Color.orange.opacity(0.4)
                                    : Color.gray.opacity(0.15), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private func emojiOnlyPicker(for question: BurnoutQuestion) -> some View {
        HStack(spacing: 8) {
            ForEach(Array((question.options ?? []).enumerated()), id: \.offset) { index, emoji in
                let isSelected = vm.selectedOptions[question.id]?.index == index
                Button {
                    handleSelection(question: question, index: index, text: emoji) // ← emoji, not option
                } label: {
                    Text(emoji)
                        .font(.system(size: 32))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isSelected
                                      ? Color.orange.opacity(0.12)
                                      : Color.white.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isSelected
                                        ? Color.orange.opacity(0.5)
                                        : Color.clear, lineWidth: 2)
                        )
                        .scaleEffect(isSelected ? 1.12 : 1.0)
                        .animation(.spring(response: 0.25), value: isSelected)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Dimension badge
    
    private func dimensionBadge(_ dimension: BurnoutDimension) -> some View {
        let (label, color, icon) = dimensionStyle(dimension)
        return HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 10))
            Text(label).font(.system(size: 10, weight: .medium))
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
    
    private func dimensionStyle(_ d: BurnoutDimension) -> (String, Color, String) {
        switch d {
        case .cargaLaboral:         return ("Carga laboral",        .orange, "briefcase")
        case .agotamientoEmocional: return ("Agotamiento",          .red,    "battery.25")
        case .despersonalizacion:   return ("Trato al cliente",     .purple, "person.2")
        case .realizacionPersonal:  return ("Realización personal", .green,  "star")
        case .indicadoresFisicos:   return ("Señales físicas",      .blue,   "heart.text.clipboard")
        }
    }
    
    // MARK: - Cards
    
    private var recommendationBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.orange)
                Text("Un pequeño paso puede ayudar")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)
            }
            ForEach(activeRecommendations.prefix(2), id: \.text) { rec in
                HStack(alignment: .top, spacing: 8) {
                    Text(rec.icon).font(.system(size: 14))
                    Text(rec.text)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(14)
        .background(Color.orange.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
        )
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
                        .foregroundColor(.orange)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Cuestionario de Seguimiento")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    Text("Responde con honestidad. Tus datos son privados y solo se usan para personalizar tus preguntas.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .padding(.trailing, 20)
                    Link(destination: URL(string: "https://pmc.ncbi.nlm.nih.gov/articles/PMC7359652/")!) {
                        HStack(spacing: 4) {
                            Text("Ver estudio de referencia")
                            Image(systemName: "arrow.up.right")
                        }
                        .font(.system(size: 10))
                        .foregroundColor(.orange.opacity(0.8))
                    }
                    .padding(.top, 2)
                    HStack(spacing: 4) {
                        Image(systemName: vm.usingAI ? "sparkles" : "gearshape")
                            .font(.system(size: 9))
                        Text(vm.usingAI ? "Apple Intelligence activo" : "Modo local activo")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(vm.usingAI ? .orange.opacity(0.7) : .secondary)
                    .padding(.top, 1)
                }
                Spacer()
                Button(action: { isHeaderVisible = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary.opacity(0.5))
                }
            }
        }
        .padding(20)
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
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [Color.orange.opacity(0.85), Color.pink.opacity(0.6)],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .opacity(vm.canSubmit ? 1 : 0.5)
        }
        .disabled(!vm.canSubmit)
    }
    
    private var loadingCard: some View {
        VStack(spacing: 14) {
            ProgressView().scaleEffect(1.2).tint(.orange)
            Text("Personalizando tus siguientes preguntas...")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var cardBackground: some ShapeStyle {
        LinearGradient(
            colors: [Color.orange.opacity(0.04), Color.green.opacity(0.03)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
}

#Preview {
    QuestionnaireView()
        .environmentObject(AppState())
}
