//
//  ViewControllerExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

extension UIViewController {
    func addRightBarButton(image: UIImage, selector: Selector){
        let rightBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        rightBarButton.tintColor = .systemYellow
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func addLeftBarButton(image: UIImage, selector: Selector){
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        leftBarButton.tintColor = .systemYellow
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func addCancelBarButton(){
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
        cancelButton.tintColor = .systemYellow
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addOkBarButton(){
        let okButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(didTapOk))
        
        okButton.tintColor = .systemYellow
        
        navigationItem.rightBarButtonItem = okButton
    }
    
    @objc func didTapOk(){}
    
    @objc func didTapCancel(){
        dismiss(animated: true)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
}
