//
//  RoutePoint.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import Foundation

/// Modelo que representa un punto en la ruta de la actividad del usuario.
struct RoutePoint {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let altitude: Double?
    let speed: Double?
    
    /// Constructor por defecto. Crea un punto sin información alguna.
    init(){
        id = UUID()
        latitude = 0.0
        longitude = 0.0
        timestamp = Date()
        altitude = 0.0
        speed = 0.0
    }
    
    /// Constructor que crea un punto de la ruta con toda la información necesaria.
    init(id: UUID, latitude: Double, longitude: Double, timestamp: Date, altitude: Double, speed: Double?){
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.altitude = altitude
        self.speed = speed
    }
}
