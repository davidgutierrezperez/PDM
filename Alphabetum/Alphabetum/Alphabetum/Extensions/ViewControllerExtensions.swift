//
//  ViewControllerExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

/// Gestiona las extensiones de los objetos UIViewController
extension UIViewController {
    /// Permite añadir un botón con un icono asociado en la parte
    /// superior derecha de la pantalla.
    /// - Parameters:
    ///   - image: icono que tendrá el botón.
    ///   - selector: acción a realizar cuando se pulse el botón.
    func addRightBarButton(image: UIImage, selector: Selector) {
        let rightBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        rightBarButton.tintColor = .systemYellow
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    /// Permite añadir un botón con un título asociado en la parte
    /// superior derecha de la pantalla.
    /// - Parameters:
    ///   - title: título que tendrá el botón.
    ///   - selector: acción a realizar cuando se pulse el botón.
    func addRightBarButton(title: String, selector: Selector){
        let rightBarButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        rightBarButton.tintColor = .systemYellow
        
        navigationItem.rightBarButtonItems?.append(rightBarButton)
    }
    
    /// Permite añadir un botón con un icono asociado en la parte
    /// superior izquierda de la pantalla.
    /// - Parameters:
    ///   - image: icono que tendrá el botón.
    ///   - selector: acción a realizar cuando se pulse el botón.
    func addLeftBarButton(image: UIImage, selector: Selector){
        let leftBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        leftBarButton.tintColor = .systemYellow
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    /// Permite crear un botón con un icono asociado que se mostrará en la
    /// parte superior de la pantalla.
    /// - Parameters:
    ///   - image: icono que tendrá el botón.
    ///   - selector: acción a realizar cuando se pulse el botón.
    /// - Returns: un objeto de tipo UIBarButtonItem ya configurado.
    func createBarButton(image: UIImage, selector: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        button.tintColor = .systemYellow
        
        return button
    }
    
    /// Permite añadir un botón para cancelar una acción en la
    /// parte superior izquierda de la pantalla.
    func addCancelBarButton(){
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
        cancelButton.tintColor = .systemYellow
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    /// Permite añadir un botón de confirmación en la parte
    /// superior derecha de la pantalla.
    func addOkBarButton(){
        let okButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(didTapOk))
        
        okButton.tintColor = .systemYellow
        
        navigationItem.rightBarButtonItem = okButton
    }
    
    /// Permite crear una barra de búsqueda con un texto a mostrar. Además, configura
    /// la actualización de resultados y el objeto que manejará la búsqueda.
    /// - Parameters:
    ///   - placeholder: texto que se mostrará en la barra de búsqueda.
    ///   - searchResultsUpdater: objeto que manejará la actualización de resultados.
    ///   - delegate: objeto que manejará la búsqueda.
    /// - Returns: un objeto de tipo UISearchController que representa una barra de búsqueda.
    func createSearchController(placeholder: String = "Search", searchResultsUpdater: UISearchResultsUpdating, delegate: UISearchBarDelegate) -> UISearchController {
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.searchBar.delegate = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholder
        
        return searchController
    }
    
    /// Cierra una vista en función de si se ha accedido a esta
    /// desde la barra de navegación desde el controlador de navegación.
    /// - Parameter animated: indica si el cierre de la vista debe ser animado.
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
    
    /// Función a sobreescribir cuando se pulsa el botón de 'Ok'.
    @objc func didTapOk(){}
    
    /// Función que cierra una vista cuando se pulsa el boton de cancelación.
    @objc func didTapCancel(){
        dismiss(animated: true)
    }
    
    /// Cierra una vista.
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
}
