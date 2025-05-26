//
//  TimeInterval+Extension.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

extension TimeInterval {
    func toString() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}

