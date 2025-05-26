//
//  Activity.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import Foundation

struct Activity {
    let id: UUID
    let date: Date
    let location: String
    let duration: TimeInterval
    let distance: Double
    let avaragePace: TimeInterval?
    let maxPace: TimeInterval?
    let avarageSpeed: Double?
    let minAltitude: Double?
    let maxAltitude: Double?
    let totalAscent: Double?
    let totalDescent: Double?
    let laps: [Lap]
    let type: TrainingType
    let route: ActivityRoute
}
