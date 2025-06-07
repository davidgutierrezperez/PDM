//
//  LapManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import CoreLocation

/// Clase que gestiona las vueltas de una actividad.
final class LapManager {
    
    /// Conjunto de vueltas de una actividad.
    private(set) var laps: [Lap] = []
    
    /// Localización de inicio de la última vuelta.
    private var lastLapStartLocation: CLLocation?
    
    /// Fecha de inicio de la última vuelta.
    private var lastLapStartTime: Date?
    
    /// Anterior localización del usuario.
    private var previousLocation: CLLocation?
    
    /// Distancia de cada vuelta.
    private let lapDistance: Double = 1000
    
    /// Distancia de la vuelta actual.
    private var currentLapDistance: Double = 0
    
    /// Ritmo máximo del usuario en una actividad.
    private(set) var maxPace: Double = 0
    
    /// Velocidad máximo del usuario en una actividad.
    private(set) var maxSpeed: Double = 0
    
    /// Inicia la primera vuelta de la actividad.
    /// - Parameters:
    ///   - location: localización del inicio de la actividad.
    ///   - time: fecha de inicio de la actividad.
    func startFirstLap(at location: CLLocation, time: Date){
        lastLapStartTime = time
        lastLapStartLocation = location
    }
    
    /// Comprueba si se ha completado una vuelta.
    /// - Parameters:
    ///   - currentLocation: localización actual del usuario.
    ///   - currentTime: fecha actual.
    /// - Returns: un objeto de tipo Lap en caso de que se haya completado una vuelta.
    func checkForNewLap(currentLocation: CLLocation, currentTime: Date) -> Lap? {
        guard let lastLapStartTime, let lastLapStartLocation else {
            print("No hay valores actualmente")
            return nil
        }
        
        if let previous = previousLocation {
            let increment = currentLocation.distance(from: previous)
            currentLapDistance += increment
        }
        
        previousLocation = currentLocation
        
        let duration = currentTime.timeIntervalSince(lastLapStartTime)
        let pace = (duration / (lapDistance / 1000)) / 60
        
        if maxPace == 0 || pace < maxPace {
            maxPace = pace
        }
        
        guard currentLapDistance >= lapDistance else { return nil }
        currentLapDistance = 0
        
        let speed = (lapDistance / 1000) / (duration / 3600)
        
        if maxSpeed < speed {
            maxSpeed = speed
        }
        
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
    
    /// Elimina toda la información del manager.
    func reset(){
        laps.removeAll()
        lastLapStartTime = nil
        lastLapStartLocation = nil
    }
    
}
