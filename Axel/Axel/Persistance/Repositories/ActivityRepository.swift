//
//  ActivityRepository.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import Foundation
import CoreData

class ActivityRepository {
    static let shared = ActivityRepository()
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    
    private init() {}
    
    public func fetchAll() -> [Activity] {
        let fetchRequest: NSFetchRequest<ActivityEntity> = NSFetchRequest(entityName: "ActivityEntity")
        
        do {
            let entities = try context.fetch(fetchRequest)
            
            let activities: [Activity] = entities.map {
                let laps = CoreDataHelper.shared.getLapsFromNSSet($0.laps!).sorted { $0.index < $1.index }
                let type = CoreDataHelper.shared.getTrainingTypeFromInt16(type: $0.type)
                let route = CoreDataHelper.shared.getRouteFromActivityEntity($0.route!)
                
                return Activity(id: $0.id ?? UUID(), date: $0.date ?? Date(), location: $0.location ?? "Desconocido", distance: $0.distance, duration: $0.duration, avaragePace: $0.avaragePace, maxPace: $0.maxPace, avarageSpeed: $0.avarageSpeed, minAltitude: $0.minAltitude, maxAltitude: $0.maxAltitude, totalAscent: $0.totalAscent, totalDescent: $0.totalDescent, laps: laps, type: type, route: route)
            }

            return activities.sorted { $0.date > $1.date }
        } catch {
            print("Error al obtener las actividades del usuario")
        }
        
        return []
    }
    
    public func fetchById(id: UUID) -> Activity? {
        let fetchRequest: NSFetchRequest<ActivityEntity> = NSFetchRequest(entityName: "ActivityEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            if let entity = try context.fetch(fetchRequest).first {
                return Activity(entity: entity)
            }
        } catch {
            print("No se ha podido obtener la actividad con ID: ", id)
        }
        
        
        return nil
    }
    
    public func create(activity: Activity){
        let context = CoreDataStack.shared.persistentContainer.viewContext

            let activityEntity = ActivityEntity(context: context)
            activityEntity.id = activity.id
            activityEntity.date = activity.date
            activityEntity.location = activity.location
            activityEntity.duration = activity.duration
            activityEntity.distance = activity.distance
            activityEntity.avaragePace = activity.avaragePace ?? 0.0
            activityEntity.minAltitude = activity.minAltitude ?? 0.0
            activityEntity.maxAltitude = activity.maxAltitude ?? 0.0
            activityEntity.totalAscent = activity.totalAscent ?? 0.0
            activityEntity.totalDescent = activity.totalDescent ?? 0.0
            activityEntity.type = activity.type.rawValue

            // Crear ruta
            let routeEntity = ActivityRouteEntity(context: context)
            routeEntity.id = activity.route.id
            routeEntity.activity = activityEntity

            var routePointsEntities: [RoutePointEntity] = []
            for point in activity.route.points {
                let pointEntity = RoutePointEntity(context: context)
                pointEntity.id = point.id
                pointEntity.latitude = point.latitude
                pointEntity.longitude = point.longitude
                pointEntity.altitude = point.altitude ?? 0.0
                pointEntity.speed = point.speed ?? 0.0
                pointEntity.timestamp = point.timestamp
                pointEntity.activityRoute = routeEntity
                routePointsEntities.append(pointEntity)
            }

            routeEntity.points = NSSet(array: routePointsEntities)
            activityEntity.route = routeEntity

            // Crear vueltas
            var lapEntities: [LapEntity] = []
            for lap in activity.laps {
                let lapEntity = LapEntity(context: context)
                lapEntity.id = lap.id
                lapEntity.duration = lap.duration ?? 0.0
                lapEntity.distance = lap.distance ?? 0.0
                lapEntity.avaragePace = lap.avaragePace
                lapEntity.avarageSpeed = lap.avarageSpeed ?? 0.0
                lapEntity.startLatitude = lap.startCoordinate.latitude
                lapEntity.startLongitude = lap.startCoordinate.longitude
                lapEntity.endLatitude = lap.endCoordinate.latitude
                lapEntity.endLongitude = lap.endCoordinate.longitude
                lapEntity.index = lap.index
                lapEntity.activity = activityEntity
                lapEntities.append(lapEntity)
            }

            activityEntity.laps = NSSet(array: lapEntities)

            do {
                try context.save()
                print("Actividad guardada correctamente")
            } catch {
                print("Error al guardar actividad: \(error)")
            }
    }
    
    public func delete(id: UUID){
        guard let entity = fetchEntityById(id: id) else { return }
        
        do {
            context.delete(entity)
            
            try context.save()
        } catch {
            print("No se ha podido borrar la actividad con ID: ", id)
        }
    }
    
    public func fetchEntityById(id: UUID) -> ActivityEntity? {
        let fetchRequest: NSFetchRequest<ActivityEntity> = NSFetchRequest(entityName: "ActivityEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let entity = try context.fetch(fetchRequest).first
            
            return entity
        } catch {
            print("No se ha podido encontrar la actividad con ID: ", id)
            return nil
        }
    }
}
