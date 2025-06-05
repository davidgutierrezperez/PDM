//
//  PaceManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import CoreLocation

final class PaceManager {
    
    static var lastPaceLocation: CLLocation?
    static var lastPaceTime: Date?
    
    static func checkForCurrentPace(lastLocation: CLLocation, currentLocation: CLLocation, timeLastLocation: Date) -> Double {
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(timeLastLocation)
        
        let distance = currentLocation.distance(from: lastLocation)
        
        print("DISTANCIA: ", distance)
        print("TIME_INTERVAL: ", timeInterval)
        
        guard distance > 0, timeInterval > 0 else { return 0.0 }
        
        let pace = (timeInterval / distance) * 1000 / 60
        print("Distancia: \(distance) m, Tiempo: \(timeInterval) s, Ritmo: \(pace) min/km")

        return pace
    }
    
    static func getAvaragePaceForActivity(for activity: Activity) -> Double {
        var avarage: Double = 0
        
        for lap in activity.laps {
            avarage += lap.avaragePace
        }
        
        return avarage / Double(activity.laps.count)
    }
    
    
}
