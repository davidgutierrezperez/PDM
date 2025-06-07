//
//  CoreDataHelper.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import CoreData
import CoreLocation

/// Clase que gestiona operaciones auxilares relacionadas con CoreData.
final class CoreDataHelper {
    
    /// Instancia única de la clase.
    static let shared = CoreDataHelper()
    
    /// Constructor por defecto de la clase.
    private init(){}
    
    /// Obtiene un array de objetos Lap a partir de un NSSet que contiene un conjunto de objetos EntityLap.
    /// - Parameter entityLaps: vueltas de actividades en formato entidad de CoreData.
    /// - Returns: un array de objetos de tipo Lap.
    func getLapsFromNSSet(_ entityLaps: NSSet) -> [Lap] {
        guard let lapEntities = entityLaps.allObjects as? [LapEntity] else { return [] }
        
        let sortedLapEntities = lapEntities.sorted { ($0.index) < ($1.index) }
        
        return sortedLapEntities.compactMap {
            let startCoordinate = CLLocationCoordinate2D(latitude: $0.startLatitude, longitude: $0.startLongitude)
            let endCoordinate = CLLocationCoordinate2D(latitude: $0.endLatitude, longitude: $0.endLongitude)
            
            return Lap(id: $0.id ?? UUID(), index: $0.index,
                       distance: $0.distance, duration: $0.duration,
                       avaragePace: $0.avaragePace, avarageSpeed: $0.avarageSpeed,
                       startCoordinate: startCoordinate, endCoordinate: endCoordinate)
        }
    }
    
    /// Obtiene la ruta de una actividad a partir de su entidad de CoreData.
    /// - Parameter entityRoute: entidad de CoreData de una actividad.
    /// - Returns: ruta de la actividad dada.
    func getRouteFromActivityEntity(_ entityRoute: ActivityRouteEntity) -> ActivityRoute {
        guard let entityPoints = entityRoute.points?.allObjects as? [RoutePointEntity] else {
            return ActivityRoute()
        }

        
        let points = entityPoints.map {
            RoutePoint(
                id: $0.id ?? UUID(),
                latitude: $0.latitude,
                longitude: $0.longitude,
                timestamp: $0.timestamp ?? Date(),
                altitude: $0.altitude,
                speed: $0.speed
            )
        }

        print("Número de puntos obtenidos: ", points.count)
        
        return ActivityRoute(id: entityRoute.id ?? UUID(), points: points)
    }
    
    /// Permite obtener el tipo de actividad a partir de un entero de 16 bits.
    /// - Parameter type: tipo de entrenamiento en formato entero de 16 bits.
    /// - Returns: devuelve un enumerado con el valor del tipo de actividad.
    func getTrainingTypeFromInt16(type: Int16) -> TrainingType {
        switch type {
        case 1:
            return .FREE_RUN
        case 2:
            return .TIME_INTERVAL
        case 3:
            return .DISTANCE_INTERVAL
        default:
            return .FREE_RUN
        }
    }
}
