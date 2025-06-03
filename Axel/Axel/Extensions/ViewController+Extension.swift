//
//  ViewController+Extension.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

extension UIViewController {
    func addDoneAndDimishButton(){
        if (navigationController!.isBeingPresented)  {
            let doneAndDismishButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissVC))
            
            navigationItem.leftBarButtonItem = doneAndDismishButton
        }
    }
    
    @objc private func dismissVC(){
        navigationController?.dismiss(animated: true)
    }
}
