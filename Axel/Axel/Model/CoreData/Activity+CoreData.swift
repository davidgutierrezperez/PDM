//
//  Activity+CoreData.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import CoreData
import CoreLocation

extension Activity {
    init?(entity: ActivityEntity){
        guard let id = entity.id,
              let date = entity.date else { return nil }
        
        self.id = id
        self.date = date
        
        self.laps = []
        self.route = ActivityRoute()
        self.type = .FREE_RUN
        
        location = entity.location ?? "Desconocido"
        duration = entity.duration
        distance = entity.distance
        avaragePace = entity.avaragePace
        maxPace = entity.maxPace
        avarageSpeed = entity.avarageSpeed
        minAltitude = entity.minAltitude
        maxAltitude = entity.maxAltitude
        totalAscent = entity.totalAscent
        totalDescent = entity.totalDescent
        laps = Activity.getLapsFromNSSet(entity.laps!)
        route = Activity.getRouteFromActivityEntity(entity.route!)
        type = Activity.getTrainingTypeFromInt16(type: entity.type)
        
    }
    
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
