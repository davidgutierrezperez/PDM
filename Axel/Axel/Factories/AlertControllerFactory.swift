//
//  AlertControllerFactory.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import UIKit

/// Clase que gestiona la creación de objetos AlertController()
final class AlertControllerFactory {
    /// Permite crear un objeto de tipo AlertController con funciones de Confirmación y Cancelación. En
    /// caso de confirmación, redirige al usuario a una vista determinada.
    /// - Parameters:
    ///   - message: mensaje a mostrar en la alerta.
    ///   - view: vista a la que se redirigirá al usuario en caso de confirmar la alerta.
    ///   - navigationController: objeto que permite la navegación entre vistas.
    ///   - onConfirm: evento a ejecutar al confirmar.
    /// - Returns: objeto de tipo UIAlertController() ya configurado.
    static func makeCancelConfirmAndRedirectAlert(message: String, view: UIViewController, navigationController: UINavigationController, onConfirm: @escaping() -> Void) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            onConfirm()
        }))
        
        return alert
    }
}
