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
            ActivityDetail(type: .duration, value: FormatHelper.formatTime(activity!.duration) ?? "-"),
            ActivityDetail(type: .distance, value: FormatHelper.formatDistance(activity!.distance) ?? "-"),
            ActivityDetail(type: .avaragePace, value: FormatHelper.formatPace(activity!.avaragePace!) ?? "-"),
            ActivityDetail(type: .maxPace, value: FormatHelper.formatPace(activity!.maxPace!) ?? "-"),
            ActivityDetail(type: .avarageSpeed, value: FormatHelper.formatPace(activity!.avarageSpeed!) ?? "-"),
            ActivityDetail(type: .minAltitude, value: FormatHelper.formatAltitude((activity?.minAltitude!)!) ?? "-"),
            ActivityDetail(type: .maxAltitude, value: FormatHelper.formatAltitude((activity?.maxAltitude!)!) ?? "-"),
            ActivityDetail(type: .totalAscent, value: FormatHelper.formatAltitude((activity?.totalAscent!)!) ?? "-"),
            ActivityDetail(type: .totalDescent, value: FormatHelper.formatAltitude((activity?.totalDescent!)!) ?? "-"),
        ]
    }
    
    
    
}
