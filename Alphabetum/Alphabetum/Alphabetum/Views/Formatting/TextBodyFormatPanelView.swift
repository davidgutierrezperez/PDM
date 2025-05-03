//
//  TextBodyFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

class TextBodyFormatPanelView: TextFormatHorizontalPanelSubView {
    
    private let boldButton = UIButton()
    private let italicButton = UIButton()
    private let underlineButton = UIButton()
    private let strikethroughButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureButtons(){
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        boldButton.setSFImageAndTarget(systemName: "bold", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        italicButton.setSFImageAndTarget(systemName: "italic", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        underlineButton.setSFImageAndTarget(systemName: "underline", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        strikethroughButton.setSFImageAndTarget(systemName: "strikethrough", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
    }
    
    override func configureStackView(){
        super.configureStackView()
        
        stackView.addArrangedSubview(boldButton)
        stackView.addArrangedSubview(italicButton)
        stackView.addArrangedSubview(underlineButton)
        stackView.addArrangedSubview(strikethroughButton)
    }
    
    @objc private func buttonTapped(_ sender: UIButton){
        if sender == boldButton {
            onFormatTap?(.bold)
        } else if sender == italicButton {
            onFormatTap?(.italic)
        } else if sender == underlineButton {
            onFormatTap?(.underline)
        } else if sender == strikethroughButton {
            onFormatTap?(.strikethrough)
        }
        
        sender.backgroundColor = (sender.backgroundColor == .systemYellow) ? .clear : .systemYellow
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }
    
}
