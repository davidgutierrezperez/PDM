//
//  LapRepository.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import CoreData

final class LapRepository {
    static let shared = LapRepository()
    
    private init() {}
    
    public func create(lap: Lap, activity: Activity){
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        do {
            guard let activityEntity = ActivityRepository.shared.fetchEntityById(id: activity.id) else {
                print("No se ha encontrado la entidad con ID: ", activity.id)
                return
            }
            
            let lapEntity = LapEntity(context: context)
            
            lapEntity.id = lap.id
            lapEntity.activity = activityEntity
            lapEntity.duration = lap.duration ?? 0.0
            lapEntity.distance = lap.distance ?? 0.0
            lapEntity.avaragePace = lap.avaragePace
            lapEntity.avarageSpeed = lap.avarageSpeed ?? 0.0
            
            lapEntity.startLatitude = lap.startCoordinate.latitude
            lapEntity.endLongitude = lap.endCoordinate.longitude
            lapEntity.endLatitude = lap.endCoordinate.latitude
            lapEntity.endLongitude = lap.endCoordinate.longitude
            
            lapEntity.index = lap.index
            
            try context.save()
            
            print("Se ha podido guardar la vuelta con ID", lap.id)
        } catch {
            print("No se ha podido guardar la vuelta con ID: ", lap.id)
        }
    }
}
