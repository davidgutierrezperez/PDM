//
//  ActivityRoute+CoreData.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import Foundation

extension ActivityRoute {
    static func getEntityFromActivityRoute(from activityRoute: ActivityRoute) -> ActivityRouteEntity {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let entity = ActivityRouteEntity(context: context)
        
        entity.points = NSSet(array: activityRoute.points)
        
        return entity
    }
}
