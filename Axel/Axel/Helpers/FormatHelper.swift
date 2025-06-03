//
//  FormatHelper.swift
//  Axel
//
//  Created by David Gutierrez on 28/5/25.
//

import Foundation

class FormatHelper {
    public static func formatDistance(_ distance: Double) -> String {
        return String(format: "%.2f km", distance)
    }
    
    public static func formatTime(_ time: TimeInterval) -> String {
        return time.toString()
    }
    
    public static func formatAltitude(_ altitude: Double) -> String {
        return String(format: "%.0f m", altitude)
    }
}
