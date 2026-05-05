import SwiftUI
import FoundationModels


struct QuestionnaireView: View {
    
    @StateObject private var store = QuestionnaireStore()
    @StateObject private var vm: QuestionnaireViewModel
    @State private var showContactsView = false
    @State private var isHeaderVisible = true
    
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
                        multipleChoiceCard
                        openQuestionCard
                        submitButton
                    }
                    
                    if store.riskLevel.shouldShowAlert {
                        riskAlertBanner
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
    }
    
    // MARK: - Subvistas
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 15) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 40, height: 40)
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: 6) {
                    Text("Cuestionario de Seguimiento")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    
                    Text("Responde con honestidad. Tus datos son privados y solo se usan para personalizar tus preguntas.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .padding(.trailing, 20) // Leave room for the 'X'
                    
                    Link(destination: URL(string: "https://pmc.ncbi.nlm.nih.gov/articles/PMC7359652/")!) {
                        HStack(spacing: 4) {
                            Text("Ver estudio de referencia")
                            Image(systemName: "arrow.up.right")
                        }
                        .font(.system(size: 10))
                        .foregroundColor(.orange.opacity(0.8))
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
                
                // Dismiss Button
                Button(action: { isHeaderVisible = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary.opacity(0.5))
                }
            }
        }
        .padding(20)
        .background(cardBackground) // Assumes you have this defined
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var multipleChoiceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(vm.multipleChoiceQuestion, systemImage: "list.bullet.clipboard")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            VStack(spacing: 10) {
                ForEach(vm.options, id: \.self) { option in
                    Button {
                        vm.selectedOption = option
                        vm.selectedOptionIndex = vm.options.firstIndex(of: option) ?? -1
                    } label: {
                        HStack {
                            Image(systemName: vm.selectedOption == option
                                  ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(vm.selectedOption == option ? .orange : .secondary)
                            Text(option)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(vm.selectedOption == option
                                      ? Color.orange.opacity(0.08)
                                      : Color.white.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(vm.selectedOption == option
                                        ? Color.orange.opacity(0.4)
                                        : Color.gray.opacity(0.15), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var openQuestionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(vm.openQuestion, systemImage: "bubble.left.and.text.bubble.right")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            ZStack(alignment: .topLeading) {
                if vm.openAnswer.isEmpty {
                    Text("Escribe aquí...")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(EdgeInsets(top: 10, leading: 6, bottom: 0, trailing: 0))
                }
                TextEditor(text: $vm.openAnswer)
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
        .padding(20)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var submitButton: some View {
        let canSubmit = vm.selectedOptionIndex >= 0 || !vm.openAnswer.isEmpty

        return Button {
            Task { await vm.submitAndGenerate() }
        } label: {
            Group {
                if vm.isSaved {
                    Label("¡Guardado!", systemImage: "checkmark.seal.fill")
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
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .opacity(canSubmit ? 1 : 0.5)
        }
        .disabled(!canSubmit)
    }
    
    private var loadingCard: some View {
        VStack(spacing: 14) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.orange)
            Text("Personalizando tus siguientes preguntas...")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // MARK: - Banner de riesgo
    
    private var riskAlertBanner: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 10) {
                Image(systemName: "heart.text.clipboard")
                    .font(.system(size: 22))
                    .foregroundColor(.pink)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Te recomendamos hablar con alguien")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
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
    }
    
    // MARK: - Helper
    
    private var cardBackground: some ShapeStyle {
        LinearGradient(
            colors: [Color.orange.opacity(0.04), Color.green.opacity(0.03)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}


#Preview {
    QuestionnaireView()
}
