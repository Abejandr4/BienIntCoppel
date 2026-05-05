// 1. Data Model
struct Message: Identifiable, Equatable {
    let id = UUID()
    let role: MessageRole
    let content: String
}
