import Foundation

struct DetectionResult {
    let level: AlertLevel
    let pattern: BurnoutPattern?
}

struct PatternDetector {
    
    static func analyze(entries: [QuestionnaireEntry]) -> DetectionResult {
        guard entries.count >= 3 else { return DetectionResult(level: .normal, pattern: nil) }
        
        let recent = Array(entries.suffix(7))
        let allResponses = recent.flatMap(\.responses)
        
        // ── 1. Puntuación por dimensión ──────────────────────────────
        var dimScores: [BurnoutDimension: Int] = [:]
        for response in allResponses {
            dimScores[response.dimension, default: 0] += response.riskWeight
        }
        
        // ── 2. Análisis de texto abierto ─────────────────────────────
        let openTexts = allResponses
            .filter { $0.questionType == .openText }
            .compactMap(\.textAnswer)
            .joined(separator: " ")
            .lowercased()
        
        let depressiveKeywords  = ["no quiero", "para qué", "sin ganas", "vacío",
                                   "llorar", "triste", "inútil", "rendirme", "solo",
                                   "no importa", "ya no puedo", "no sirvo"]
        let fatigueKeywords     = ["agotado", "sin energía", "no duermo", "cansado",
                                   "no descanso", "desvelo", "pesadez", "colapso"]
        let cynicismKeywords    = ["no me importa", "harto", "fastidio", "molestia",
                                   "qué flojera", "para qué esforzarse", "da igual"]
        
        let depressiveHits  = depressiveKeywords.filter { openTexts.contains($0) }.count
        let fatigueHits     = fatigueKeywords.filter { openTexts.contains($0) }.count
        let cynicismHits    = cynicismKeywords.filter { openTexts.contains($0) }.count
        
        // ── 3. Tendencia de empeoramiento ────────────────────────────
        let isWorsening = checkWorsening(entries: recent)
        
        // ── 4. Consistencia: cuántos días consecutivos con peso alto ──
        let consecutiveHighDays = countConsecutiveHighRiskDays(entries: recent)
        
        // ── 5. Determinar patrón dominante ───────────────────────────
        let pattern = dominantPattern(
            dimScores: dimScores,
            depressiveHits: depressiveHits,
            fatigueHits: fatigueHits,
            cynicismHits: cynicismHits
        )
        
        // ── 6. Calcular nivel de alerta ───────────────────────────────
        var score = 0
        score += (dimScores.values.max() ?? 0)           // pico de dimensión
        score += depressiveHits * 3
        score += fatigueHits * 2
        score += cynicismHits * 2
        score += isWorsening ? 4 : 0
        score += consecutiveHighDays * 3
        
        // Penalización extra si hay 2+ dimensiones críticas simultáneas
        let criticalDims = dimScores.filter { $0.value >= 6 }.count
        if criticalDims >= 2 { score += 5 }
        
        let level: AlertLevel
        switch score {
        case 0...5:   level = .normal
        case 6...10:  level = .watch
        case 11...18: level = .warning
        default:      level = .critical
        }
        
        return DetectionResult(level: level, pattern: pattern)
    }
    
    // MARK: - Helpers
    
    private static func dominantPattern(
        dimScores: [BurnoutDimension: Int],
        depressiveHits: Int,
        fatigueHits: Int,
        cynicismHits: Int
    ) -> BurnoutPattern? {
        
        guard let max = dimScores.values.max(), max > 0 else { return nil }
        
        let criticalDims = dimScores.filter { $0.value >= max - 1 }.map(\.key)
        
        if criticalDims.count >= 3 { return .combined }
        
        if depressiveHits >= 3 { return .depressiveSigns }
        
        if let dominant = criticalDims.first {
            switch dominant {
            case .agotamientoEmocional: return fatigueHits >= 2 ? .fatigueChronic : .emotionalExhaustion
            case .despersonalizacion:   return .depersonalization
            case .indicadoresFisicos:   return .physicalDeterioration
            case .cargaLaboral:         return fatigueHits >= 2 ? .fatigueChronic : .emotionalExhaustion
            case .realizacionPersonal:  return depressiveHits >= 1 ? .depressiveSigns : .emotionalExhaustion
            }
        }
        return nil
    }
    
    private static func checkWorsening(entries: [QuestionnaireEntry]) -> Bool {
        guard entries.count >= 3 else { return false }
        let last3 = entries.suffix(3)
        let avgWeights: [Double] = last3.map { entry in
            let weights = entry.responses.map(\.riskWeight)
            return weights.isEmpty ? 0 : Double(weights.reduce(0, +)) / Double(weights.count)
        }
        return avgWeights[0] < avgWeights[1] && avgWeights[1] < avgWeights[2]
    }
    
    private static func countConsecutiveHighRiskDays(entries: [QuestionnaireEntry]) -> Int {
        var count = 0
        for entry in entries.reversed() {
            let avg = entry.responses.map(\.riskWeight).reduce(0, +)
            if avg >= 4 { count += 1 } else { break }
        }
        return count
    }
}
