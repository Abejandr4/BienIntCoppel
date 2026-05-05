import Foundation
internal import Combine

@MainActor
final class AppState: ObservableObject {
    
    @Published var alertLevel: AlertLevel = .normal
    @Published var dominantPattern: BurnoutPattern? = nil
    
    func update(from entries: [QuestionnaireEntry]) {
        let result = PatternDetector.analyze(entries: entries)
        alertLevel = result.level
        dominantPattern = result.pattern
    }
}
