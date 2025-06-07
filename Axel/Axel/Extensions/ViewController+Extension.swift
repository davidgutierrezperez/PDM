//
//  ViewController+Extension.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

/// Extensiones del componente UIViewController()
extension UIViewController {
    
    /// Permite añadir un botón en la esquina superior izquierda que al pulsar oculte la vista actual.
    func addDoneAndDimishButton(){
        if (navigationController!.isBeingPresented)  {
            let doneAndDismishButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissVC))
            
            navigationItem.leftBarButtonItem = doneAndDismishButton
        }
    }
    
    func addBarButtonAndAction(title: String, onRight: Bool, selector: Selector){
        let actionButton = UIBarButtonItem(title: title, style: .done, target: self, action: selector)
        
        if (onRight){
            navigationItem.rightBarButtonItem = actionButton
        } else {
            navigationItem.leftBarButtonItem = actionButton
        }
        
    }
    
    /// Oculta la vista actual.
    @objc private func dismissVC(){
        navigationController?.dismiss(animated: true)
    }
    
    func redirectToViewWithoutBackButton(view: UIViewController){
        view.navigationItem.hidesBackButton = true
        
        navigationController?.pushViewController(view, animated: true)
    }
}
