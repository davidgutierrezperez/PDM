//
//  CreateEntityViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

final class CreateEntityViewModel {
    private(set) var text: String = ""
    
    var isValid: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func updateText(_ newText: String){
        text = newText
    }
}
