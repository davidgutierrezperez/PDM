//
//  TextFormattingOptionsView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

class TextFormattingOptionsView: TextFormatPanelHorizontalView {
    
    private let formattingTextButton = UIButton()
    private let insertImageButton = UIButton()
    
    private let textFormatOptionsPanel = TextBodyFormatPanelView()
    
    var onBoldTap: (() -> Void)?
    var onItalicTap: (() -> Void)?
    var onUnderlineTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray2
        
        configureTextFormatOptionsPanel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func showTextFormattingOptions(){
        textFormatOptionsPanel.isHidden.toggle()
        invalidateIntrinsicContentSize()
        
        stackView.alignment = .center
        stackView.distribution = .equalCentering
    }
    
    private func configureTextFormatOptionsPanel(){
        addSubview(textFormatOptionsPanel)
        textFormatOptionsPanel.isHidden = true
        textFormatOptionsPanel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFormatOptionsPanel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            textFormatOptionsPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textFormatOptionsPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textFormatOptionsPanel.heightAnchor.constraint(equalToConstant: 50) // o el tamaño necesario
        ])

        textFormatOptionsPanel.onBoldTap = { [weak self] in
            self?.onBoldTap?()
        }
        
        textFormatOptionsPanel.onItalicTap = { [weak self] in
            self?.onItalicTap?()
        }
        
        textFormatOptionsPanel.onUnderlineTap = { [weak self] in
            self?.onUnderlineTap?()
        }
    }
    
    override func configureButtons(){
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        
        formattingTextButton.setImage(UIImage(systemName: "textformat", withConfiguration: buttonConfig), for: .normal)
        formattingTextButton.addTarget(self, action: #selector(showTextFormattingOptions), for: .touchUpInside)
        
        insertImageButton.setImage(UIImage(systemName: "paperclip", withConfiguration: buttonConfig), for: .normal)
        
        formattingTextButton.tintColor = .systemYellow
        insertImageButton.tintColor = .systemYellow
    }
    
    override func configureStackView(){
        super.configureStackView()
        
        stackView.addArrangedSubview(formattingTextButton)
        stackView.addArrangedSubview(insertImageButton)
    }
    
    override var intrinsicContentSize: CGSize {
        let baseHeight: CGFloat = 50
        let panelHeight: CGFloat = textFormatOptionsPanel.isHidden ? 0 : 75
        return CGSize(width: UIView.noIntrinsicMetric, height: baseHeight + panelHeight)
    }

}
