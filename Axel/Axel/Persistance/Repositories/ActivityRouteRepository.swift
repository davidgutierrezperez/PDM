//
//  ActivityRouteRepository.swift
//  Axel
//
//  Created by David Gutierrez on 4/6/25.
//

import CoreData

final class ActivityRouteRepository {
    static let shared = ActivityRouteRepository()
    
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    
    public func create(for activity: Activity){
        let activityRouteEntity = ActivityRouteEntity(context: context)
        
        guard let activityEntity = ActivityRepository.shared.fetchEntityById(id: activity.id) else { return }
                    
        activityRouteEntity.id = activity.route.id
        activityRouteEntity.activity = activityEntity
            
        var routePointEntities: [RoutePointEntity] = []
            
        for point in activity.route.points {
            let routePointEntity = RoutePointEntity(context: context)
                
            routePointEntity.id = point.id
            routePointEntity.activityRoute = activityRouteEntity
            routePointEntity.altitude = point.altitude ?? 0.0
            routePointEntity.latitude = point.latitude
            routePointEntity.longitude = point.longitude
            routePointEntity.speed = point.speed ?? 0.0
            routePointEntity.timestamp = point.timestamp
                
            routePointEntities.append(routePointEntity)
        }
            
        activityRouteEntity.points = NSSet(array: routePointEntities)
            
        do {
            try context.save()
        } catch {
            print("No se pudo crear una ruta de actividad")
        }
    }
    
    public func fetchByActivity(activity: Activity) -> ActivityRoute? {
        guard let activity = ActivityRepository.shared.fetchById(id: activity.id) else { return nil }
        
        return activity.route
    }
}
