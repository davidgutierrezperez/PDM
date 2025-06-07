//
//  TimeInterval+Extension.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

/// Extensiones de TimeInterval
extension TimeInterval {
    
    /// Permite pasar a String un objeto de tipo TimeInterval
    /// - Returns: un String con el contenido del TimeInterval en formato -> min:seg
    func toString() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}

