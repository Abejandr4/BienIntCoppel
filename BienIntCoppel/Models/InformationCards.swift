//
//  Estadisticas.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 11 on 05/05/26.
//

import Foundation

struct FichaInformativa : Decodable {
    var id: String
    var boldText: String
    var normalText: String
    var image: String
}


let fichas: [FichaInformativa] = [
    FichaInformativa(
        id: "H-A",
        boldText: "¿Sabías que...",
        normalText: "3 de cada 4 mexicanos sufre de estrés laboral agudo.",
        image: ""
    ),
    FichaInformativa(
        id: "H-B",
        boldText: "Y recuerda",
        normalText: "cuídarte también es cuidar de los que más amas",
        image: ""
    ),
    FichaInformativa(
        id: "H-C",
        boldText: "¡No importa el género!",
        normalText: "El estrés y la fátiga puede sucederle a cualquiera",
        image: ""
    ),
    FichaInformativa(
        id: "H-D",
        boldText: "No estás solo",
        normalText: "busca acompañamiento con un psicólogo de un CEDIS si crees que es necesario",
        image: ""
    ),
    FichaInformativa(
        id: "H-E",
        boldText: "Fátiga crónica",
        normalText: "sentirse extremadamente agotado todo el tiempo no es saludable, busca atención",
        image: ""
    )
]
