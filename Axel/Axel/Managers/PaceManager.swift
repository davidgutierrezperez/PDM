//
//  PaceManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import CoreLocation

final class PaceManager {
    
    static func checkForCurrentPace(lastLocation: CLLocation, currentLocation: CLLocation, timeLastLocation: Date) -> Double {
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(timeLastLocation)
        
        let distance = currentLocation.distance(from: lastLocation)
        
        guard distance != 0.0 else { return 0.0 }
        
        return (100 / (distance / timeInterval) / 60)
    }
    
    static func getAvaragePaceForActivity(for activity: Activity) -> Double {
        var avarage: Double = 0
        
        for lap in activity.laps {
            avarage += lap.avaragePace
        }
        
        return avarage / Double(activity.laps.count)
    }
    
    
}
