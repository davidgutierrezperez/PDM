//
//  Activity.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import Foundation

struct Activity {
    let id: UUID
    let date: Date
    var location: String
    var duration: TimeInterval
    var distance: Double
    var avaragePace: TimeInterval?
    var maxPace: TimeInterval?
    var avarageSpeed: Double?
    var minAltitude: Double?
    var maxAltitude: Double?
    var totalAscent: Double?
    var totalDescent: Double?
    var laps: [Lap]
    var type: TrainingType
    var route: ActivityRoute
    
    init(){
        id = UUID()
        date = Date()
        location = "Desconocido"
        duration = TimeInterval()
        distance = 0.0
        avaragePace = TimeInterval()
        maxPace = TimeInterval()
        avarageSpeed = 0.0
        minAltitude = 0.0
        maxAltitude = 0.0
        totalAscent = 0.0
        totalDescent = 0.0
        laps = []
        type = .FREE_RUN
        route = ActivityRoute()
    }
    
    init(id: UUID, date: Date, location: String,
         distance: Double, duration: Double, avaragePace: TimeInterval, maxPace: TimeInterval,
         avarageSpeed: Double, minAltitude: Double, maxAltitude: Double,
         totalAscent: Double, totalDescent: Double, laps: [Lap], type: TrainingType, route: ActivityRoute){
        self.id = id
        self.date = date
        self.location = location
        self.duration = duration
        self.distance = distance
        self.avaragePace = avaragePace
        self.maxPace = maxPace
        self.avarageSpeed = avarageSpeed
        self.minAltitude = minAltitude
        self.maxAltitude = maxAltitude
        self.totalAscent = totalAscent
        self.totalDescent = totalDescent
        self.laps = laps
        self.type = type
        self.route = route
    }
}
