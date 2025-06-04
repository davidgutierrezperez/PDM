//
//  FormatHelper.swift
//  Axel
//
//  Created by David Gutierrez on 28/5/25.
//

import Foundation

class FormatHelper {
    public static func formatDistance(_ distance: Double) -> String {
        let kilometers = distance / 1000
        return String(format: "%.2f km", kilometers)
    }
    
    public static func formatTime(_ time: TimeInterval) -> String {
        return time.toString()
    }
    
    public static func formatAltitude(_ altitude: Double) -> String {
        return String(format: "%.0f m", altitude)
    }
    
    public static func formatPace(_ pace: Double, showUnit: Bool = false) -> String {
        guard pace.isFinite && pace > 0 else { return "– min/km" }

        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        let format: String = (showUnit) ? "%d:%02d min/km" : "%d:%02d"
        return String(format: format, minutes, seconds)
    }

}
