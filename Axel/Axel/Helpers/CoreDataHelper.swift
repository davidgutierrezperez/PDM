//
//  CoreDataHelper.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import CoreData
import CoreLocation

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private init(){}
    
    func getLapsFromNSSet(_ entityLaps: NSSet) -> [Lap] {
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
    
    func getRouteFromActivityEntity(_ entityRoute: ActivityRouteEntity) -> ActivityRoute {
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
