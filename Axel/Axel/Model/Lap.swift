//
//  Lap.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit
import CoreLocation

struct Lap {
    let index: Int
    let distance: Double?
    let duration: TimeInterval?
    let avaragePace: Double
    let avarageSpeed: Double?
    
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D
}
