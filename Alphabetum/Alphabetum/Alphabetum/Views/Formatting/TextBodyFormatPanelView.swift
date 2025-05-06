//
//  TextBodyFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

/// Clase que representa la vista asociada a un panel horizontal con múltiples botones
/// asociados al formato de texto.
class TextBodyFormatPanelView: TextFormatHorizontalPanelSubView {
    
    /// Botón que activa el formato de texto en **negrita**
    private let boldButton = UIButton()
    
    /// Botón que activa el formato de texto en *itálica*.
    private let italicButton = UIButton()
    
    /// Botón que activa el formato de texto subrayado.
    private let underlineButton = UIButton()
    
    /// Botón que activa el formato de texto tachado.
    private let strikethroughButton = UIButton()
    
    /// Constructor por defecto de la clase. Establece los diferentes formatos de texto
    /// del panel.
    /// - Parameter frame: frame que representa el objeto de la clase.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        formatButtons = [
            .bold: boldButton,
            .italic: italicButton,
            .underline: underlineButton,
            .strikethrough: strikethroughButton
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura los diferentes botones de la vista.
    override func configureButtons(){
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        boldButton.setSFImageAndTarget(systemName: "bold", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        italicButton.setSFImageAndTarget(systemName: "italic", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        underlineButton.setSFImageAndTarget(systemName: "underline", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        strikethroughButton.setSFImageAndTarget(systemName: "strikethrough", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
    }
    
    /// Configura el stackView de la vista y añade los diferentes botones.
    override func configureStackView(){
        super.configureStackView()
        
        stackView.addArrangedSubview(boldButton)
        stackView.addArrangedSubview(italicButton)
        stackView.addArrangedSubview(underlineButton)
        stackView.addArrangedSubview(strikethroughButton)
    }
    
    /// Gestiona el evento de pulsar sobre un botón de formato de texto y
    /// actualiza su estado.
    /// - Parameter sender: botón que ha sido pulsado.
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
    
    override func updateButtons(with formats: Set<TextFormat>) {
        for (format, button) in formatButtons {
            button.backgroundColor = formats.contains(format) ? .systemYellow : .clear
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }
    
}
