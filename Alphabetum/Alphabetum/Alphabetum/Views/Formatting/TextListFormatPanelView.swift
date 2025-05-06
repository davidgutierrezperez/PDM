//
//  TextListFormatPanelView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 3/5/25.
//

import UIKit

/// Clase que representa la vista con el panel que posee los botones para establecer
/// el tipo de lista a insertar en una nota.
class TextListFormatPanelView: TextFormatHorizontalPanelSubView {
    
    /// Botón que activa el tipo de lista ' *' .
    private let bulletListButton = UIButton()
    
    /// Botón que activa el tipo de lista ' - ' .
    private let dashListButton = UIButton()
    
    /// Botón que activa el tipo de lista enumerada.
    private let numberedListButton = UIButton()

    /// Constructor por defecto de la clase. Establece los diferentes formatos de texto
    /// del panel.
    /// - Parameter frame: frame que representa el objeto de la clase.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        formatButtons = [
            .bulletlist: bulletListButton,
            .dashList: dashListButton,
            .numberedList: numberedListButton
        ]
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura los diferentes botones de la vista.
    override func configureButtons() {
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        bulletListButton.setSFImageAndTarget(systemName: "list.bullet", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        dashListButton.setSFImageAndTarget(systemName: "list.dash", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
        numberedListButton.setSFImageAndTarget(systemName: "list.number", configuration: buttonConfig, target: self, selector: #selector(buttonTapped(_:)))
    }
    
    /// Configura el stackView de la vista y añade los diferentes botones.
    override func configureStackView() {
        super.configureStackView()
        
        stackView.addArrangedSubview(bulletListButton)
        stackView.addArrangedSubview(dashListButton)
        stackView.addArrangedSubview(numberedListButton)
    }

    /// Gestiona el evento de pulsar sobre un botón de formato de texto y
    /// actualiza su estado.
    /// - Parameter sender: botón que ha sido pulsado.
    @objc private func buttonTapped(_ sender: UIButton){
        var newFormat: TextFormat = .bulletlist
        
        if sender == bulletListButton {
            newFormat = .bulletlist
        } else if sender == dashListButton {
            newFormat = .dashList
        } else if sender == numberedListButton {
            newFormat = .numberedList
        }
        
        onFormatTap?(newFormat)
        
        changeButtonBackgroundColorWithinContext(sender, newFormat: newFormat)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}
