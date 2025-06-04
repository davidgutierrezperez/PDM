//
//  LapManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import CoreLocation

final class LapManager {
    private(set) var laps: [Lap] = []
    private var lastLapStartLocation: CLLocation?
    private var lastLapStartTime: Date?
    
    private var previousLocaiton: CLLocation?
    
    private let lapDistance: Double = 20
    private var currentLapDistance: Double = 0
    
    func startFirstLap(at location: CLLocation, time: Date){
        lastLapStartTime = time
        lastLapStartLocation = location
    }
    
    func checkForNewLap(currentLocation: CLLocation, currentTime: Date) -> Lap? {
        guard let lastLapStartTime, let lastLapStartLocation else {
            print("No hay valores actualmente")
            return nil
        }
        
        if let previous = previousLocaiton {
            let increment = currentLocation.distance(from: previous)
            currentLapDistance += increment
        }
        
        previousLocaiton = currentLocation
        
        guard currentLapDistance >= lapDistance else { return nil }
        currentLapDistance = 0
        
        print("He pasado")
        
        let duration = currentTime.timeIntervalSince(lastLapStartTime)
        let pace = (duration / (lapDistance / 1000)) / 60
        let speed = (lapDistance / 1000) / (duration / 3600)
        
        let lap = Lap(
                    id: UUID(),
                    index: Int16(laps.count + 1),
                    distance: lapDistance,
                    duration: duration,
                    avaragePace: pace,
                    avarageSpeed: speed,
                    startCoordinate: lastLapStartLocation.coordinate,
                    endCoordinate: currentLocation.coordinate
                )
        
        laps.append(lap)
        
        self.lastLapStartTime = currentTime
        self.lastLapStartLocation = currentLocation
        
        return lap
    }
    
    func reset(){
        laps.removeAll()
        lastLapStartTime = nil
        lastLapStartLocation = nil
    }
    
}
