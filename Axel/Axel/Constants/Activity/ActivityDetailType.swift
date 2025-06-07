//
//  ActivityDetail.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import Foundation

/// Tipos de estadística a mostrar para cada actividad.
enum ActivityDetailType: String, CaseIterable {
    case avaragePace = "Ritmo medio"
    case maxPace = "Ritmo máx."
    case avarageSpeed = "Máx. velocidad"
    case minAltitude = "Altura mín."
    case maxAltitude = "Máx. altura"
    case totalAscent = "Ascenso total"
    case totalDescent = "Descenso total"
    case duration = "Duración"
    case distance = "Distancia"
    case empty = ""
}
