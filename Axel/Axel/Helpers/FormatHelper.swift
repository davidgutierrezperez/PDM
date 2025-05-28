//
//  FormatHelper.swift
//  Axel
//
//  Created by David Gutierrez on 28/5/25.
//

import Foundation

class FormatHelper {
    public static func formatDistance(_ distance: Double) -> String {
        return String(format: "%.2f KM", distance)
    }
}
