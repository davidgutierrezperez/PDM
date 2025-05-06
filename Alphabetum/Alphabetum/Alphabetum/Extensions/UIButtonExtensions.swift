//
//  UIButtonExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

/// Gestiona las extensiones de objetos UIButton.
extension UIButton {
    /// Configura un botón asignandole un icono, un tamaño, una acción a realizar cuando es pulsado, un color y la vista sobre
    /// la que se mostrará.
    /// - Parameters:
    ///   - systemName: nombre del icono que mostrará el botón.
    ///   - configuration: configuración con el tamaño que tendrá el icono.
    ///   - target: vista sobre la que se mostrará el botón.
    ///   - selector: acción que se llevará a cabo cuando se pulse el botón.
    ///   - tintColor: color del botón.
    func setSFImageAndTarget(systemName: String, configuration: UIImage.SymbolConfiguration, target: Any?, selector: Selector, tintColor: UIColor = .white){
        self.setImage(UIImage(systemName: systemName, withConfiguration: configuration), for: .normal)
        self.tintColor = tintColor
        setTarget(target: target, selector: selector)
    }
    
    /// Asigna un título y una acción a realizar al botón.
    /// - Parameters:
    ///   - title: título del botón.
    ///   - target: vista sobre la que se mostrará el botón.
    ///   - selector: accíon a realizar cuando se pulse el botón.
    func setTitleAndTarget(title: String, target: Any?, selector: Selector){
        self.setTitle(title, for: .normal)
        setTarget(target: target, selector: selector)
    }
    
    /// Asigna una acción al botón y la vista sobre la que se mostrará el botón
    /// y lo gestionará.
    /// - Parameters:
    ///   - target: vista que gestionará el botón.
    ///   - selector: acción a realizar cuando se pulse el botón.
    func setTarget(target: Any?, selector: Selector){
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
}
