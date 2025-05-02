//
//  TextFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

class TextFormatPanelView: TextFormatPanelHorizontalView {
    
    private let textBodyFormatPanel = TextBodyFormatPanelView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureStackView(){
        super.configureStackView()
        
        stackView.addArrangedSubview(textBodyFormatPanel)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
