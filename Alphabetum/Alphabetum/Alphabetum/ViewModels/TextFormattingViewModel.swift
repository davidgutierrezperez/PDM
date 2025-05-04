//
//  TextFormattingViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import Foundation

class TextFormattingViewModel {
    private(set) var activeFormats: Set<TextFormat> = []
    
    func updateActiveFormats(_ formats: Set<TextFormat>){
        activeFormats = formats
    }
    
    func toggle(_ format: TextFormat){
        if activeFormats.contains(format){
            activeFormats.remove(format)
        } else {
            activeFormats.insert(format)
        }
    }
    
    func isActive(_ format: TextFormat) -> Bool {
        return activeFormats.contains(format)
    }
}
