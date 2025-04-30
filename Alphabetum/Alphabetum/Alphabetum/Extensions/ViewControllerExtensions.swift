//
//  ViewControllerExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

extension UIViewController {
    func addRightBarButton(image: UIImage, selector: Selector) {
        let rightBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        rightBarButton.tintColor = .systemYellow
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func addLeftBarButton(image: UIImage, selector: Selector){
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        leftBarButton.tintColor = .systemYellow
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func createBarButton(image: UIImage, selector: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        button.tintColor = .systemYellow
        
        return button
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
    
    func createSearchController(placeholder: String = "Search", searchResultsUpdater: UISearchResultsUpdating, delegate: UISearchBarDelegate) -> UISearchController {
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.searchBar.delegate = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholder
        
        return searchController
    }
    
    func closeSelf(animated: Bool){
        if let nav = navigationController {
            if nav.viewControllers.first == self {
                dismiss(animated: animated)
            } else {
                nav.popViewController(animated: animated)
            }
        } else {
            dismiss(animated: animated)
        }
    }
    
    @objc func didTapOk(){}
    
    @objc func didTapCancel(){
        dismiss(animated: true)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
}
