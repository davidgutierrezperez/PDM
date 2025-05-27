//
//  Lap.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit
import CoreLocation

struct Lap {
    let id: UUID
    let index: Int16
    let distance: Double?
    let duration: TimeInterval?
    let avaragePace: Double
    let avarageSpeed: Double?
    
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D
    
    init(){
        id = UUID()
        index = 0
        distance = 0.0
        duration = TimeInterval()
        avaragePace = 0.0
        avarageSpeed = 0.0
        startCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        endCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    init(id: UUID,
         index: Int16,
         distance: Double?,
         duration: TimeInterval?,
         avaragePace: Double,
         avarageSpeed: Double?,
         startCoordinate: CLLocationCoordinate2D,
         endCoordinate: CLLocationCoordinate2D){
        self.id = id
        self.index = index
        self.distance = distance
        self.duration = duration
        self.avaragePace = avaragePace
        self.avarageSpeed = avarageSpeed
        self.startCoordinate = startCoordinate
        self.endCoordinate = endCoordinate
    }
}
