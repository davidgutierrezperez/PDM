//
//  TextFormatHorizontalPanelSubView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 3/5/25.
//

import UIKit

/// Clase que representa la vista de un panel horizontal con botones.
class TextFormatHorizontalPanelSubView: TextFormatPanelHorizontalView {
    
    /// Variable que indica el último formato seleccionado.
    var lastSelectedFormat: TextFormat = .body
    
    /// Variable que indica el último botón seleccionado.
    var lastSelectedButton: UIButton? = nil
    
    /// Variable que indica el formato de texto seleccionado.
    var onFormatTap: ((TextFormat) -> Void)?
    
    /// Conjunto de formatos y sus botones asociados.
    var formatButtons: [TextFormat: UIButton] = [:]
    
    /// Constructor por defecto de la clase.
    /// - Parameter frame: frame que representa el objeto de la clase.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Actualiza el color de fondo de un botón en función de su estado.
    /// - Parameters:
    ///   - sender: botón pulsado.
    ///   - newFormat: nuevo formato del texto.
    func changeButtonBackgroundColorWithinContext(_ sender: UIButton, newFormat: TextFormat){
        if newFormat != lastSelectedFormat {
            lastSelectedButton?.backgroundColor = .clear
            
            sender.backgroundColor = .systemYellow
            
            lastSelectedButton = sender
            lastSelectedFormat = newFormat
        } else {
            sender.backgroundColor = .clear
            lastSelectedButton = nil
            lastSelectedFormat = .body
            
            onFormatTap?(.body)
        }
    }
    
    /// Actualiza los estados de todos los botones en función de los formatos activos.
    /// - Parameter formats: formatos activos actualmente en el texto.
    func updateButtons(with formats: Set<TextFormat>) {
        for (format, button) in formatButtons {
            button.backgroundColor = formats.contains(format) ? .systemYellow : .clear
        }
    }
    
}
