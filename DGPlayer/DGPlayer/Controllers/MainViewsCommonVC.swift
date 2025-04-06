//
//  MainViewsCommonVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

/// Controlador común para las vistas principales de la aplicación.
class MainViewsCommonVC: UIViewController {
    
    /// Objecto que permite hacer *scroll* en las vistas principales
    let scrollView = UIScrollView()
    
    /// Boton asociada al evento de añadir elementos.
    var addButton = UIBarButtonItem()
    
    /// Contructor por defecto de la clase *MainViewsCommonVC* y por
    /// tanto de las principales vistas de la aplicación.
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Inicializador requerido para cargar la vista desde un archivo storyboard o nib.
    ///
    /// Este inicializador es necesario cuando se utiliza Interface Builder para crear
    /// instancias del controlador. En este caso particular, como el controlador se
    /// configura completamente de forma programática, el uso de storyboards no está soportado,
    /// por lo que se lanza un `fatalError` si se intenta usar.
    ///
    /// - Parameter coder: Objeto utilizado para decodificar la vista desde un archivo nib o storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Eventos a ocurrir cuando la vista carga por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton = configureAddButton()
    }
    
    /// Configura el botón asociado a eventos de añadir elementos.
    func configureAddButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.tintColor = .systemRed
        
        return addButton
    }
    
    /// Permite añadir un evento a un boton de tipo *UIBarButtonItem*.
    /// - Parameters:
    ///   - boton: botón a configurar.
    ///   - target: vista desde la que se ejecutará el evento asociado al botón.
    ///   - action: evento/función asociado al botón.
    func addTargetToBarButton(boton: UIBarButtonItem, target: AnyObject?, action: Selector) {
        boton.target = target
        boton.action = action
    }

}
