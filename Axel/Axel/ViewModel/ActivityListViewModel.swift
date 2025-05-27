//
//  ActivityListViewModel.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import Foundation

class ActivityListViewModel {
    static let shared = ActivityListViewModel()
    
    private let repository = ActivityRepository.shared
    
    private var activities: [Activity]
    
    private init(){
        activities = []
    }
    
    func fetch(){
        activities = repository.fetchAll()
    }
    
    func add(activity: Activity){
        
    }
    
    func at(_ index: Int) -> Activity? {
        return activities[index]
    }
    
    func getCount() -> Int {
        print("Número de actividades: ", activities.count)
        return activities.count
    }
}
