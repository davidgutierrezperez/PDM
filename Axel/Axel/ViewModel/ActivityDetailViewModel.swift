//
//  ActivityDetailViewModel.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import Foundation

class ActivityDetailViewModel {
    private let repository = ActivityRepository.shared
    
    private let activity: Activity?
    
    init(id: UUID){
        activity = repository.fetchById(id: id)
    }
    
    func getId() -> UUID {
        return activity?.id ?? UUID()
    }
}
