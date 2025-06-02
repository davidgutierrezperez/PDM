//
//  LiveActivityViewModel.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import Foundation
import CoreLocation

final class LiveActivityViewModel {
    var activity: Activity?
    
    private(set) var status = ActivityStatus.NOT_INTIATED
    private var durationTimer: Timer?
    
    private let locationSertice = LocationService()
    private let repository = ActivityRepository.shared
    
    init(){
        activity = Activity()
    }
    
    func startActivity(){
        locationSertice.requestCity{ [weak self] city in
            self?.activity?.location = city ?? "Desconocido"
            print("LA CIUDAD ES: ", city ?? "Nada")
        }
        
        status = ActivityStatus.ACTIVE
    }
    
    func pauseActivity(){
        status = ActivityStatus.PAUSED
    }
    
    func resumeActivity(){
        status = ActivityStatus.ACTIVE
    }
    
    func endActivity(){
        guard let activity = activity else { return }

        status = ActivityStatus.ENDED
        repository.create(activity: activity)
    }
    
    func discardActivity(){
        activity = nil
        status = ActivityStatus.DISCARDED
    }
    
 
    
    
}
