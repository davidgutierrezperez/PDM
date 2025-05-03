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
    private(set) var isStrikeThrough: Bool = false
    private(set) var isTitle: Bool = false
    private(set) var isHeader: Bool = false
    private(set) var isSubtitle: Bool = false
    private(set) var isBody: Bool = true
    private(set) var isBulletlist: Bool = false
    private(set) var isDashList: Bool = false
    
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
        case .strikethrough:
            isStrikeThrough.toggle()
            break
        case .title:
            isTitle.toggle()
            break
        case .header:
            isHeader.toggle()
            break
        case .subtitle:
            isSubtitle.toggle()
            break
        case .bulletlist:
            isBulletlist.toggle()
            break
        case .dashList:
            isDashList.toggle()
            break
        default:
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
