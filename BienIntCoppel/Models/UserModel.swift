import SwiftUI

struct User {
    let fullName: String
    
    // Computed property for the first name (Hola Ana)
    var firstName: String {
        fullName.components(separatedBy: " ").first ?? "Usuario"
    }
    
    // Computed property for initials (AR)
    var initials: String {
        let components = fullName.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }
        return String(initials.prefix(2)).uppercased()
    }
}
