//
//  AlertCancelConfirm.swift
//  Alphabetum
//
//  Created by David Gutierrez on 5/5/25.
//

import UIKit

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
