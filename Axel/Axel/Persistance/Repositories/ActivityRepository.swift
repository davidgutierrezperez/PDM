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
                let laps = CoreDataHelper.shared.getLapsFromNSSet($0.laps!)
                let type = CoreDataHelper.shared.getTrainingTypeFromInt16(type: $0.type)
                let route = CoreDataHelper.shared.getRouteFromActivityEntity($0.route!)
                
                return Activity(id: $0.id ?? UUID(), date: $0.date ?? Date(), location: $0.location ?? "Desconocido", distance: $0.distance, duration: $0.duration, avaragePace: $0.avaragePace, maxPace: $0.maxPace, avarageSpeed: $0.avarageSpeed, minAltitude: $0.minAltitude, maxAltitude: $0.maxAltitude, totalAscent: $0.totalAscent, totalDescent: $0.totalDescent, laps: laps, type: type, route: route)
            }
            
            return activities
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
        
        do {
            let entity = ActivityEntity(context: context)
            
            entity.id = activity.id
            entity.date = activity.date
            entity.location = activity.location
            entity.duration = activity.duration
            entity.distance = activity.distance
            entity.avaragePace = activity.avaragePace ?? 0.0
            entity.minAltitude = activity.minAltitude ?? 0.0
            entity.maxAltitude = activity.maxAltitude ?? 0.0
            entity.totalAscent = activity.totalAscent ?? 0.0
            entity.totalDescent = activity.totalDescent ?? 0.0
            entity.laps = Lap.getNSSetFromLapArray(laps: activity.laps)
            entity.type = activity.type.rawValue
            entity.route = ActivityRoute.getEntityFromActivityRoute(from: activity.route)
            
            CoreDataStack.shared.saveContext()
        } catch {
            print("No se puedo guardar la nueva actividad")
        }
    }
    
    func delete(id: UUID){
        guard let entity = fetchEntityById(id: id) else { return }
        
        do {
            context.delete(entity)
            
            try context.save()
        } catch {
            print("No se ha podido borrar la actividad con ID: ", id)
        }
    }
    
    private func fetchEntityById(id: UUID) -> ActivityEntity? {
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
