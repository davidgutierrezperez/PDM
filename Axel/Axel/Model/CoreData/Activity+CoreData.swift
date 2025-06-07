//
//  Activity+CoreData.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import CoreData
import CoreLocation

/// Extensión que gestiona la creación de una actividad a partir de la
/// información obtenida de CoreData.
extension Activity {
    
    /// Constructor que permite crear un activdad a partir de la información
    /// almacenada en CoreData de la actividad.
    /// - Parameter entity: entidad de CoreData que contiene la información de la actividad.
    init(entity: ActivityEntity) {
            let laps = CoreDataHelper.shared.getLapsFromNSSet(entity.laps ?? [])
                .sorted { $0.index < $1.index }

            let type = CoreDataHelper.shared.getTrainingTypeFromInt16(type: entity.type)

            let route = CoreDataHelper.shared.getRouteFromActivityEntity(entity.route!)

            self.init(
                id: entity.id ?? UUID(),
                date: entity.date ?? Date(),
                location: entity.location ?? "Desconocido",
                distance: entity.distance,
                duration: entity.duration,
                avaragePace: entity.avaragePace,
                maxPace: entity.maxPace,
                avarageSpeed: entity.avarageSpeed,
                minAltitude: entity.minAltitude,
                maxAltitude: entity.maxAltitude,
                totalAscent: entity.totalAscent,
                totalDescent: entity.totalDescent,
                laps: laps,
                type: type,
                route: route
            )
    }
    
    /// Permite obtener un array de intervalos a partir de un objeto de tipo NSSet proporciando por CoreData.
    /// - Parameter entityLaps: objeto de tipo NSSet proporciando por CoreData que contiene información de los intervalos de la actividad.
    /// - Returns: un array de tipo Lap con la información sobre los intervalos de la actividad.
    static func getLapsFromNSSet(_ entityLaps: NSSet) -> [Lap] {
        guard let lapEntities = entityLaps.allObjects as? [LapEntity] else { return [] }
        
        return lapEntities.compactMap {
            let startCoordinate = CLLocationCoordinate2D(latitude: $0.startLatitude, longitude: $0.startLongitude)
            let endCoordinate = CLLocationCoordinate2D(latitude: $0.endLatitude, longitude: $0.endLongitude)
            
            return Lap(id: $0.id ?? UUID(), index: $0.index,
                       distance: $0.distance, duration: $0.duration,
                       avaragePace: $0.avaragePace, avarageSpeed: $0.avarageSpeed,
                       startCoordinate: startCoordinate, endCoordinate: endCoordinate)
        }
    }
    
    /// Permite obtener un ruta de un actividad.
    /// - Parameter entityRoute: información de CoreData sobre la ruta de una actividad.
    /// - Returns: objeto de tipo ActivityRoute que representa la ruta de una actividad.
    static func getRouteFromActivityEntity(_ entityRoute: ActivityRouteEntity) -> ActivityRoute {
        guard let entityPoints = entityRoute.points?.allObjects as? [RoutePoint] else { return ActivityRoute() }
        
        let points = entityPoints.map {
                RoutePoint(
                    id: $0.id,
                    latitude: $0.latitude,
                    longitude: $0.longitude,
                    timestamp: $0.timestamp,
                    altitude: $0.altitude ?? 0.0,
                    speed: $0.speed
            )
        }
        
        return ActivityRoute(id: entityRoute.id ?? UUID(), points: points)
    }
    
    /// Permite obtener el tipo de entrenamiento a partir de un entero de 16 bits.
    /// - Parameter type: entero de 16 bits que representa el tipo de entrenamiento.
    /// - Returns: enumerado de tipo TrainingType que representa el tipo de actividad que llevará a cabo el usuario.
    static func getTrainingTypeFromInt16(type: Int16) -> TrainingType {
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
