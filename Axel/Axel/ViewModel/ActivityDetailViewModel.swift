//
//  ActivityDetailViewModel.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import Foundation

class ActivityDetailViewModel {
    private let repository = ActivityRepository.shared
    
    private(set) var activity: Activity?
    private(set) var details: [ActivityDetail] = []
    
    init(id: UUID){
        let activityDetailStore = ActivityDetailStore.shared
        
        if (activityDetailStore.activity?.id != id){
            activityDetailStore.loadActivity(id: id)
        }
        
        activity = activityDetailStore.activity
        
        details = [
            ActivityDetail(type: .duration, value: activity?.duration.toString() ?? "-"),
            ActivityDetail(type: .distance, value: activity?.distance.toString() ?? "-"),
            ActivityDetail(type: .avaragePace, value: activity?.avaragePace?.toString() ?? "-"),
            ActivityDetail(type: .maxPace, value: activity?.maxPace?.toString() ?? "-"),
            ActivityDetail(type: .avarageSpeed, value: activity?.avarageSpeed?.toString() ?? "-"),
            ActivityDetail(type: .minAltitude, value: activity?.minAltitude?.toString() ?? "-"),
            ActivityDetail(type: .maxAltitude, value: activity?.maxAltitude?.toString() ?? "-"),
            ActivityDetail(type: .totalAscent, value: activity?.totalAscent?.toString() ?? "-"),
            ActivityDetail(type: .totalDescent, value: activity?.totalDescent?.toString() ?? "-"),
        ]
    }
    
    
    
}
