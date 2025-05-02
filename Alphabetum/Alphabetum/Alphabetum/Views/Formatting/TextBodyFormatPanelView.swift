//
//  TextBodyFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

class TextBodyFormatPanelView: TextFormatPanelHorizontalView {
    
    private let boldButton = UIButton()
    private let italicButton = UIButton()
    private let underlineButton = UIButton()
    
    var onFormatTap: ((TextFormat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureButtons(){
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        boldButton.setSFImageAndTarget(systemName: "bold", configuration: buttonConfig, target: self, selector: #selector(boldButtonTapped))
        italicButton.setSFImageAndTarget(systemName: "italic", configuration: buttonConfig, target: self, selector: #selector(italicButtonTapped))
        underlineButton.setSFImageAndTarget(systemName: "underline", configuration: buttonConfig, target: self, selector: #selector(underlineButtonTapped))
    }
    
    override func configureStackView(){
        super.configureStackView()
        
        stackView.addArrangedSubview(boldButton)
        stackView.addArrangedSubview(italicButton)
        stackView.addArrangedSubview(underlineButton)
    }
    
    private func configureButton(button: inout UIButton, systemName: String, configuration: UIImage.SymbolConfiguration, selector: Selector){
        button.setImage(UIImage(systemName: systemName, withConfiguration: configuration), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    @objc private func boldButtonTapped(){
        onFormatTap?(.bold)
    }
    
    @objc private func italicButtonTapped(){
        onFormatTap?(.italic)
    }
    
    @objc private func underlineButtonTapped(){
        onFormatTap?(.underline)
    }
    
}
