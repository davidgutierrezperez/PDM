//
//  RoutePoint.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import Foundation

struct RoutePoint {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let altitude: Double?
    let speed: Double?
    
    init(){
        id = UUID()
        latitude = 0.0
        longitude = 0.0
        timestamp = Date()
        altitude = 0.0
        speed = 0.0
    }
    
    init(id: UUID, latitude: Double, longitude: Double, timestamp: Date, altitude: Double, speed: Double?){
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.altitude = altitude
        self.speed = speed
    }
}
