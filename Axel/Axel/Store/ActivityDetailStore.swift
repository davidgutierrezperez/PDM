//
//  ActivityDetailStore.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import Foundation

final class ActivityDetailStore {
    static let shared = ActivityDetailStore()
    
    private let repository = ActivityRepository.shared
    private(set) var activity: Activity?
    
    private init(){}
    
    func loadActivity(id: UUID){
        activity = repository.fetchById(id: id)
    }
    
    func clear(){
        self.activity = nil
    }
}
