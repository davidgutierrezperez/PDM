//
//  TextHeadingFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 3/5/25.
//

import UIKit

class TextHeadingFormatPanelView: TextFormatPanelHorizontalView {
    
    private let titleButton = UIButton()
    private let headerButton = UIButton()
    private let subtitleButton = UIButton()
    
    private var lastFormatSelected: TextFormat = .body
    private var lastSelectedButton: UIButton? = nil
    
    var onFormatTap: ((TextFormat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureButtons() {
        super.configureButtons()
        
        titleButton.setTitleAndTarget(title: "Title", target: self, selector: #selector(buttonTapped(_:)))
        headerButton.setTitleAndTarget(title: "Header", target: self, selector: #selector(buttonTapped(_:)))
        subtitleButton.setTitleAndTarget(title: "Subtitle", target: self, selector: #selector(buttonTapped(_:)))
    }
    
    override func configureStackView() {
        super.configureStackView()
        
        stackView.addArrangedSubview(titleButton)
        stackView.addArrangedSubview(headerButton)
        stackView.addArrangedSubview(subtitleButton)
    }
    
    @objc private func buttonTapped(_ sender: UIButton){
        var newFormat: TextFormat = .body
        
        if sender == titleButton {
            newFormat = .title
        } else if sender == headerButton {
            newFormat = .header
        } else if sender == subtitleButton {
            newFormat = .subtitle
        }
        
        onFormatTap?(newFormat)

        if newFormat != lastFormatSelected {
            lastSelectedButton?.backgroundColor = .clear
            
            sender.backgroundColor = .systemYellow
            
            lastSelectedButton = sender
            lastFormatSelected = newFormat
        } else {
            sender.backgroundColor = .clear
            lastSelectedButton = nil
            lastFormatSelected = .body
            
            onFormatTap?(.body)
        }
        
        
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}
