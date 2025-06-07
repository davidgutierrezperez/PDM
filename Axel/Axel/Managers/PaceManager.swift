//
//  PaceManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import CoreLocation

/// Clase que getiona la gestión del ritmo del usuario durante una actividad.
final class PaceManager {
    
    /// Última ubicación del usuario durante una actividad mientras está en movimiento
    static var lastPaceLocation: CLLocation?
    
    /// Último momento en el que el usuario se ha movido durante una actividad.
    static var lastPaceTime: Date?
    
    /// Permite obtener el ritmo actual del usuario durante una actividad.
    /// - Parameters:
    ///   - lastLocation: última ubicación del usuario.
    ///   - currentLocation: ubicación actual del usuario.
    ///   - timeLastLocation: momento de la última ubicación del usuario.
    /// - Returns: un Double que representa el ritmo actual del usuario.
    static func checkForCurrentPace(lastLocation: CLLocation, currentLocation: CLLocation, timeLastLocation: Date) -> Double {
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(timeLastLocation)
        
        let distance = currentLocation.distance(from: lastLocation)
        
        guard distance > 0, timeInterval > 0 else { return 0.0 }
        
        let pace = (timeInterval / distance) * 1000 / 60
        
        return pace
    }
    
    /// Permite obtener el ritmo medio de una actividad.
    /// - Parameter activity: actividad del usuario.
    /// - Returns: un Double que representa el ritmo medio del usuario durante una actividad.
    static func getAvaragePaceForActivity(for activity: Activity) -> Double {
        var avarage: Double = 0
        
        for lap in activity.laps {
            avarage += lap.avaragePace
        }
        
        return avarage / Double(activity.laps.count)
    }
    
    
    
    
}
