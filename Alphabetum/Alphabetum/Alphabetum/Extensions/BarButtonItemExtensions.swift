//
//  BarButtonItemExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 5/5/25.
//

import UIKit

/// Gestiona las extensiones de objetos UIBarbuttonItem.
extension UIBarButtonItem {
    /// Configura un botón con una imagen y un acción asociada.
    /// - Parameters:
    ///   - systemName: nombre del icono asociado a la imagen que tendrá el botón.
    ///   - selector: acción que se llevará a cabo al pulsar el botón.
    ///   - target: vista sobre la que se ejecutará el botón.
    func configureButton(systemName: String, selector: Selector, target: AnyObject?){
        self.title = nil
        self.image = UIImage(systemName: systemName)
        self.style = .plain
        self.action = selector
        self.target = target
        self.tintColor = .systemYellow
    }
    
    /// Configura un botón con un título y una acción asociada.
    /// - Parameters:
    ///   - title: titulo que tendrá el botón.
    ///   - selector: acción que se llevará a cabo al pulsar el botón.
    ///   - target: vista sobre la que se ejecutará el botón.
    func configureButton(title: String, selector: Selector, target: AnyObject?){
        self.image = nil
        self.title = title
        self.style = .plain
        self.action = selector
        self.target = target
        self.tintColor = .systemYellow
    }
}
