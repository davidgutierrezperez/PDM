//
//  AlertCancelConfirm.swift
//  Alphabetum
//
//  Created by David Gutierrez on 5/5/25.
//

import UIKit

/// Crea un controlador de alertas con un botón de cancelación y otro de confirmación.
/// - Parameters:
///   - title: título que tendrá la alerta del controlador.
///   - placeholder: texto que se mostrará en el *TextField* de la alerta.
///   - action: acción a realizar cuando se pulse sobre el botón de confirmación.
/// - Returns: un objeto de tipo UIAlertController que representa el controlador de alertas ya configurado.
func makeAlertCancelConfirm(title: String, placeholder: String, action: @escaping ((String) -> Void)) -> UIAlertController {
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    
    alert.addTextField { textfield in
        textfield.placeholder = placeholder
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
        let text = alert.textFields?.first?.text ?? ""
        action(text)
    }
        
    alert.addAction(cancelAction)
    alert.addAction(confirmAction)
        
    return alert
}
