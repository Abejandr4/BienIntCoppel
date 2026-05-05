import Foundation

enum AlertLevel: String, Codable {
    case normal
    case watch
    case warning
    case critical
    
    var isAlarmante: Bool { self == .warning || self == .critical }
    
    var color: String {
        switch self {
        case .normal:   return "green"
        case .watch:    return "yellow"
        case .warning:  return "orange"
        case .critical: return "red"
        }
    }
}

enum BurnoutPattern: String {
    case fatigueChronic         = "Fatiga crónica"
    case emotionalExhaustion    = "Agotamiento emocional"
    case depressiveSigns        = "Señales depresivas"
    case depersonalization      = "Despersonalización"
    case physicalDeterioration  = "Deterioro físico"
    case combined               = "Burnout combinado"
}
