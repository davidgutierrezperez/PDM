//
//  TextFormattingViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import Foundation

class TextFormattingViewModel {
    private(set) var isBold: Bool = false
    private(set) var isItalic: Bool = false
    private(set) var isUnderline: Bool = false
    
    func toggleTextFomat(_ format: TextFormat){
        switch(format){
        case .bold:
            isBold.toggle()
            break
        case .italic:
            isItalic.toggle()
            break
        case .underline:
            isUnderline.toggle()
            break
        }
    }
    
    func toggleBold(){
        isBold.toggle()
    }
    
    func toggleItalic(){
        isItalic.toggle()
    }
    
    func toggleUnderline(){
        isUnderline.toggle()
    }
}
