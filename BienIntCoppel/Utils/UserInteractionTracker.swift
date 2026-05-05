import Foundation
internal import Combine

// MARK: - UserInteractionTracker
// Guarda y recupera los clics por categoría usando UserDefaults.
// Agrégalo a la carpeta Utils de tu proyecto.

class UserInteractionTracker: ObservableObject {
    
    static let shared = UserInteractionTracker()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let respiracion  = "clicks_respiracion"
        static let mindfulness  = "clicks_mindfulness"
        static let somatico     = "clicks_somatico"
        static let escritura    = "clicks_escritura"
        static let diasActivos  = "dias_activos"
        static let ultimoAcceso = "ultimo_acceso"
    }
    
    // MARK: - Clicks por categoría
    @Published var clicksRespiracion: Int  { didSet { defaults.set(clicksRespiracion,  forKey: Keys.respiracion) } }
    @Published var clicksMindfulness: Int  { didSet { defaults.set(clicksMindfulness,  forKey: Keys.mindfulness) } }
    @Published var clicksSomatico: Int     { didSet { defaults.set(clicksSomatico,      forKey: Keys.somatico) } }
    @Published var clicksEscritura: Int    { didSet { defaults.set(clicksEscritura,     forKey: Keys.escritura) } }
    @Published var diasActivos: Int        { didSet { defaults.set(diasActivos,          forKey: Keys.diasActivos) } }
    
    // MARK: - Init
    private init() {
        self.clicksRespiracion = defaults.integer(forKey: Keys.respiracion)
        self.clicksMindfulness = defaults.integer(forKey: Keys.mindfulness)
        self.clicksSomatico    = defaults.integer(forKey: Keys.somatico)
        self.clicksEscritura   = defaults.integer(forKey: Keys.escritura)
        self.diasActivos       = defaults.integer(forKey: Keys.diasActivos)
        
        actualizarDiasActivos()
    }
    
    // MARK: - Registrar clic
    func registrarClic(categoria: String) {
        switch categoria.lowercased() {
        case "respiracion": clicksRespiracion += 1
        case "mindfulness": clicksMindfulness += 1
        case "somatico":    clicksSomatico    += 1
        case "escritura":   clicksEscritura   += 1
        default: break
        }
    }
    
    // MARK: - Días activos
    // Incrementa la racha si el usuario abre la app en un día nuevo.
    private func actualizarDiasActivos() {
        let hoy = Calendar.current.startOfDay(for: Date())
        
        if let ultimoData = defaults.object(forKey: Keys.ultimoAcceso) as? Date {
            let ultimo = Calendar.current.startOfDay(for: ultimoData)
            let diferencia = Calendar.current.dateComponents([.day], from: ultimo, to: hoy).day ?? 0
            
            if diferencia == 1 {
                diasActivos += 1             // día consecutivo
            } else if diferencia > 1 {
                diasActivos = 1             // se rompió la racha
            }
            // diferencia == 0: mismo día, no cambiar
        } else {
            diasActivos = 1                 // primer acceso
        }
        
        defaults.set(hoy, forKey: Keys.ultimoAcceso)
    }
    
    // MARK: - Reset (útil para testing)
    func resetearTodo() {
        clicksRespiracion = 0
        clicksMindfulness = 0
        clicksSomatico    = 0
        clicksEscritura   = 0
        diasActivos       = 0
        defaults.removeObject(forKey: Keys.ultimoAcceso)
    }
}
