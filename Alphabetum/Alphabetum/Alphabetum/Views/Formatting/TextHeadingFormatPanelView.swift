//
//  TextHeadingFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 3/5/25.
//

import UIKit

/// Clase que representa la vista con el panel que posee los botones para establecer
/// el tipo de texto a insertar en una nota.
class TextHeadingFormatPanelView: TextFormatHorizontalPanelSubView {
    
    /// Botón que activa el formato de tipo 'Título'.
    private let titleButton = UIButton()
    
    /// Botón que activa el formato de tipo 'Encabezado'.
    private let headerButton = UIButton()
    
    /// Botón que activa el formato de tipo 'Subtítulo'.
    private let subtitleButton = UIButton()
    
    /// Constructor por defecto de la clase. Establece los diferentes formatos de texto
    /// del panel.
    /// - Parameter frame: frame que representa el objeto de la clase.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        formatButtons = [
            .title: titleButton,
            .header: headerButton,
            .subtitle: subtitleButton
        ]

    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura los diferentes botones de la vista.
    override func configureButtons() {
        super.configureButtons()
        
        titleButton.setTitleAndTarget(title: "Title", target: self, selector: #selector(buttonTapped(_:)))
        headerButton.setTitleAndTarget(title: "Header", target: self, selector: #selector(buttonTapped(_:)))
        subtitleButton.setTitleAndTarget(title: "Subtitle", target: self, selector: #selector(buttonTapped(_:)))
    }
    
    /// Configura el stackView de la vista y añade los diferentes botones.
    override func configureStackView() {
        super.configureStackView()
        
        stackView.addArrangedSubview(titleButton)
        stackView.addArrangedSubview(headerButton)
        stackView.addArrangedSubview(subtitleButton)
    }
    
    /// Gestiona el evento de pulsar sobre un botón de formato de texto y
    /// actualiza su estado.
    /// - Parameter sender: botón que ha sido pulsado.
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

        changeButtonBackgroundColorWithinContext(sender, newFormat: newFormat)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}
