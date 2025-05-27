//
//  Lap+CoreData.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import Foundation

extension Lap {
    static func getNSSetFromLapArray(laps: [Lap]) -> NSSet {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let lapEntities = laps.compactMap { lap in
            let lapEntity = LapEntity(context: context)
            
            lapEntity.id = lap.id
            lapEntity.index = lap.index
            lapEntity.distance = lap.distance ?? 0.0
            lapEntity.duration = lap.duration ?? 0.0
            lapEntity.avaragePace = lap.avaragePace
            lapEntity.avarageSpeed = lap.avarageSpeed ?? 0.0
            lapEntity.startLongitude = lap.startCoordinate.longitude
            lapEntity.startLatitude = lap.startCoordinate.latitude
            lapEntity.endLatitude = lap.endCoordinate.latitude
            lapEntity.endLongitude = lap.endCoordinate.longitude
            
            return lapEntity
        }
        
        return NSSet(array: lapEntities)
    }
}
