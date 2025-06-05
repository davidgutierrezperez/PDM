//
//  AlertControllerFactory.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import UIKit

final class AlertControllerFactory {
    static func makeCancelConfirmAndRedirectAlert(message: String, view: UIViewController, navigationController: UINavigationController, onConfirm: @escaping() -> Void) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            onConfirm()
        }))
        
        return alert
    }
}
