//
//  TextListFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 3/5/25.
//

import UIKit

class TextListFormatPanelView: TextFormatHorizontalPanelSubView {
    
    private let bulletListButton = UIButton()
    private let dashListButton = UIButton()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureButtons() {
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        bulletListButton.setSFImageAndTarget(systemName: "list.bullet", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        dashListButton.setSFImageAndTarget(systemName: "list.dash", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
    }
    
    override func configureStackView() {
        super.configureStackView()
        
        stackView.addArrangedSubview(bulletListButton)
        stackView.addArrangedSubview(dashListButton)
    }

    @objc private func buttonTapped(_ sender: UIButton){
        var newFormat: TextFormat = .bulletlist
        
        if sender == bulletListButton {
            newFormat = .bulletlist
        } else if sender == dashListButton {
            newFormat = .dashList
        }
        
        onFormatTap?(newFormat)
        
        changeButtonBackgroundColorWithinContext(sender, newFormat: newFormat)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}
