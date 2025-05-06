//
//  GeneralTabBar.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

/// Clase que representa el TabBar de la aplicación.
final class AlphabetumTabBar: UITabBarController {
    
    /// Nombre del icono que tendrá el botón de creación de notas.
    static let CreateNoteIcon = "square.and.pencil"
    
    /// Nombre del icono que tendrá el botón para acceder a la lista de carpetas creadas.
    static let FolderListIcon = "folder"
    
    /// Eventos a ocurrir cuando la vista carga por primera vez. Aquí se incluye la
    /// configuración de la vista.
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabs()
    }
    
    /// Indica los controladores de vista que tendrá el *TabBar* para acceder a otras vistas.
    private func configureTabs(){
        viewControllers = [setupFolderNavigationController(), setupNoteNavigationController()]
    }
    
    /// Crea un controlador de navegación para acceder a una nueva vista.
    /// - Parameters:
    ///   - viewController: vista a la que se accederá cuando se pulse sobre el controlador de navegación.
    ///   - tabBarItem: item que representa el botón del controlador de navegación.
    /// - Returns: un objeto de tipo UINavigationController que permite acceder a otra vista.
    private func createNavigationController(viewController: UIViewController, tabBarItem: UITabBarItem) -> UINavigationController {
        viewController.tabBarItem = tabBarItem
        viewController.tabBarItem.title = nil
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        return UINavigationController(rootViewController: viewController)
    }
    
    /// Crea un item con un icono asociado. Este item estará asociado a un controlador de navegación.
    /// - Parameters:
    ///   - image: imagen que tendrá el item.
    ///   - tag: índice del item en el *TabBar*.
    /// - Returns: un objeto de tipo UIBarItem que representa un botón a mostrar en el *TabBar*.
    private func createTabBarItem(_ image: UIImage!,_ tag: Int) -> UITabBarItem {
        let coloredImage = image.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        
        
        return UITabBarItem(title: nil, image: coloredImage, tag: tag)
    }
    
    /// Configura el controlador de navegación que permite acceder a la vista de creación de notas.
    /// - Returns: objeto de tipo UINavigationController ya configurado.
    private func setupNoteNavigationController() -> UINavigationController {
        let noteVC = NoteVC()
        let noteTabBarItem = createTabBarItem(UIImage(systemName: Self.CreateNoteIcon), 1)
        
        
        return createNavigationController(viewController: noteVC, tabBarItem: noteTabBarItem)
    }
    
    /// Configura el controlador de navegación que permite acceder a la vista que contiene la lista de carpetas almacenadas en el sistema.
    /// - Returns: objeto de tipo UINavigationController ya configurado.
    private func setupFolderNavigationController() -> UINavigationController {
        let createFolderVC = FolderListVC()
        let createFolderTabBarItem = createTabBarItem(UIImage(systemName: Self.FolderListIcon), 2)
        
        return createNavigationController(viewController: createFolderVC, tabBarItem: createFolderTabBarItem)
    }

}
