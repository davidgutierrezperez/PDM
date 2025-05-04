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
    private let textHeadingFormatOptionsPanel = TextHeadingFormatPanelView()
    private let textListFormatOptionsPanel = TextListFormatPanelView()
    
    private let verticalStackView = UIStackView()
    
    var onFormatTap: ((TextFormat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .darkGray
        
        configureTextFormatOptionsPanel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateButtons(with formats: Set<TextFormat>){
        textFormatOptionsPanel.updateButtons(with: formats)
        textHeadingFormatOptionsPanel.updateButtons(with: formats)
        textListFormatOptionsPanel.updateButtons(with: formats)
    }
    
    @objc private func showTextFormattingOptions() {
        let shoudExpand = verticalStackView.arrangedSubviews.isEmpty
        
        if shoudExpand {
            verticalStackView.addArrangedSubview(textFormatOptionsPanel)
            verticalStackView.addArrangedSubview(textListFormatOptionsPanel)
            verticalStackView.addArrangedSubview(textHeadingFormatOptionsPanel)
        } else {
            textFormatOptionsPanel.removeFromSuperview()
            textListFormatOptionsPanel.removeFromSuperview()
            textHeadingFormatOptionsPanel.removeFromSuperview()
        }
        
        verticalStackView.isHidden.toggle()

        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    private func configureTextFormatOptionsPanel() {
        addSubview(verticalStackView)

        verticalStackView.isHidden = true
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints para que se vea y ocupe espacio
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Propagar los closures
        textFormatOptionsPanel.onFormatTap = { [weak self] format in
            self?.onFormatTap?(format)
        }
        
        textListFormatOptionsPanel.onFormatTap = { [weak self] format in
            self?.onFormatTap?(format)
        }

        textHeadingFormatOptionsPanel.onFormatTap = { [weak self] format in
            self?.onFormatTap?(format)
        }

        configureVerticalStackView()
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
    
    private func configureVerticalStackView(){
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 15
        verticalStackView.alignment = .center
        verticalStackView.distribution = .equalCentering
    }
    
    override var intrinsicContentSize: CGSize {
        let baseHeight: CGFloat = 50
        
        guard !verticalStackView.isHidden else {
            return CGSize(width: UIView.noIntrinsicMetric, height: baseHeight)
        }
        
        let panelHeight = verticalStackView.systemLayoutSizeFitting(
                CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height)
            ).height
        
        return CGSize(width: UIView.noIntrinsicMetric, height: panelHeight + baseHeight)
    }

}
