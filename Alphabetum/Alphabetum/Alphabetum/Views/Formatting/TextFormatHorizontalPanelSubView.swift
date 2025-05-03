//
//  TextFormatHorizontalPanelSubView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 3/5/25.
//

import UIKit

class TextFormatHorizontalPanelSubView: TextFormatPanelHorizontalView {
    
    var lastSelectedFormat: TextFormat = .body
    var lastSelectedButton: UIButton? = nil
    var onFormatTap: ((TextFormat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeButtonBackgroundColorWithinContext(_ sender: UIButton, newFormat: TextFormat){
        if newFormat != lastSelectedFormat {
            lastSelectedButton?.backgroundColor = .clear
            
            sender.backgroundColor = .systemYellow
            
            lastSelectedButton = sender
            lastSelectedFormat = newFormat
        } else {
            sender.backgroundColor = .clear
            lastSelectedButton = nil
            lastSelectedFormat = .body
            
            onFormatTap?(.body)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
