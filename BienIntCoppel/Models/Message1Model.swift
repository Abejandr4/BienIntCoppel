import Foundation // Required for UUID

// 1. You must define the type that you are using in the struct
enum MessageRole: String, Codable, Equatable {
    case user
    case assistant
    case system
}

// 2. Data Model
struct Message: Identifiable, Equatable {
    let id = UUID()
    let role: MessageRole
    let content: String
}
