//
//  WellnessRecommendations.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 11 on 05/05/26.
//

import Foundation

struct WellnessRecommendation {
    let icon: String
    let text: String
}

struct WellnessRecommendations {
    
    // Recomendaciones por dimensión y peso de la respuesta elegida
    static func recommendations(
        for dimension: BurnoutDimension,
        riskWeight: Int
    ) -> [WellnessRecommendation] {
        guard riskWeight >= 2 else { return [] }
        
        switch dimension {
            
        case .cargaLaboral:
            return [
                WellnessRecommendation(icon: "💬",
                    text: "Cuéntale a un compañero de confianza cómo estuvo tu día. A veces solo con eso baja la presión."),
                WellnessRecommendation(icon: "🚶",
                    text: "Si puedes, da una caminata corta al salir de tu turno antes de llegar a casa. Ayuda a \"cerrar\" el día."),
                WellnessRecommendation(icon: "📵",
                    text: "Intenta no revisar temas del trabajo en tu primer hora en casa. Ese tiempo es tuyo."),
            ]
            
        case .agotamientoEmocional:
            return [
                WellnessRecommendation(icon: "🫂",
                    text: "Habla con alguien cercano esta noche, aunque sea de algo que no tenga que ver con el trabajo."),
                WellnessRecommendation(icon: "🎮",
                    text: "Reserva aunque sea 20 minutos para hacer algo que disfrutes. Tu cerebro lo necesita."),
                WellnessRecommendation(icon: "😴",
                    text: "Intenta dormir a la misma hora hoy. El sueño regular es una de las formas más efectivas de recuperar energía emocional."),
            ]
            
        case .despersonalizacion:
            return [
                WellnessRecommendation(icon: "👥",
                    text: "Platícalo con un compañero que también atienda clientes. Saber que no eres el único ayuda mucho."),
                WellnessRecommendation(icon: "🌱",
                    text: "Recuerda un momento reciente donde ayudaste a alguien de verdad. Eso también eres tú."),
                WellnessRecommendation(icon: "☕",
                    text: "Tómate tu descanso de verdad hoy: sin pensar en metas ni en el siguiente cliente."),
            ]
            
        case .realizacionPersonal:
            return [
                WellnessRecommendation(icon: "🗣️",
                    text: "Comparte con alguien de confianza cómo te has sentido en el trabajo últimamente."),
                WellnessRecommendation(icon: "✍️",
                    text: "Escribe una cosa pequeña que sí salió bien hoy, aunque parezca insignificante."),
                WellnessRecommendation(icon: "🎯",
                    text: "Piensa en algo que te gustaba hacer antes y que has dejado de lado. ¿Puedes retomarlo esta semana?"),
            ]
            
        case .indicadoresFisicos:
            return [
                WellnessRecommendation(icon: "🧘",
                    text: "Antes de dormir, tómate 5 minutos para respirar profundo. No es meditación, es solo darte espacio."),
                WellnessRecommendation(icon: "💧",
                    text: "¿Tomaste suficiente agua hoy? A veces el dolor de cabeza y el cansancio vienen de ahí."),
                WellnessRecommendation(icon: "🚑",
                    text: "Si el dolor físico es frecuente, cuéntaselo a alguien o busca orientación médica. Tu cuerpo te está hablando."),
            ]
        }
    }
    
    // Recomendaciones para nivel de alerta global (banner en otras pantallas)
    static func globalRecommendations(for level: AlertLevel) -> [WellnessRecommendation] {
        switch level {
        case .normal, .watch:
            return []
        case .warning:
            return [
                WellnessRecommendation(icon: "🫂",
                    text: "Habla con alguien de confianza sobre cómo te has sentido esta semana."),
                WellnessRecommendation(icon: "🎯",
                    text: "Dedica tiempo esta semana a algo que genuinamente disfrutes, aunque sea poco."),
            ]
        case .critical:
            return [
                WellnessRecommendation(icon: "❤️",
                    text: "Llevas varios días con señales de agotamiento. Hablar con alguien —amigo, familiar o profesional— puede hacer una gran diferencia."),
                WellnessRecommendation(icon: "🗣️",
                    text: "No tienes que cargarlo solo/a. Cuéntale a alguien cómo te has sentido."),
            ]
        }
    }
}
