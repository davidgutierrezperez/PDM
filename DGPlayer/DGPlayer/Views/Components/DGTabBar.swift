//
//  DGTabBar.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

/// Controlador asociado al *TabBar* de la aplicación.
class DGTabBar: UITabBarController {

    /// Eventos a ocurrir cuando la vista se carga por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    /// Eventos a ocurrir cuando se incluye una subvista en la vista principal del controlador.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let song = SongPlayerManager.shared.song else { return }

        SongPlayerFooterVC.shared.updateView(with: song)
        SongPlayerFooterVC.shared.show(in: self)
    }
    
    /// Configura la interfaz de la vista del controlador.
    private func configure(){
        tabBar.backgroundColor = .systemFill
        tabBar.tintColor = .systemRed
        tabBar.isTranslucent = false
        
        let homeVC = configureNavigationController(viewController: HomeVC(),
                                                   title: "Home",
                                                   tabBarItem: UITabBarItem(title: "Home",
                                                                            image: UIImage(systemName: "headphones"),
                                                                            selectedImage: UIImage(systemName: "headphones")))
        
        let favoritesVC = configureNavigationController(viewController: FavoritesVC(),
                                                        title: "Favorites",
                                                        tabBarItem: UITabBarItem(tabBarSystemItem: .favorites, tag: 1))
        
        let playlistVC = configureNavigationController(viewController: PlaylistVC(),
                                                       title: "Playlists",
                                                       tabBarItem: UITabBarItem(title: "Playlists",
                                                                                image: UIImage(systemName: "music.note.list"),
                                                                                selectedImage: UIImage(systemName: "music.note.list")))
        
        viewControllers = [homeVC, favoritesVC, playlistVC]
    }
    
    /// Permite configurar un controlador de navegación.
    /// - Parameters:
    ///   - viewController: controlador al que se accederá a partir del controlador de navegación.
    ///   - title: título del controlador de navegación.
    ///   - tabBarItem: elemento a incluir en el *TabBar* asociado al controlador de navegación.
    /// - Returns: <#description#>
    private func configureNavigationController(viewController: UIViewController, title: String, tabBarItem: UITabBarItem) -> UINavigationController {
        viewController.title = title
        viewController.tabBarItem = tabBarItem
        viewController.tabBarItem.title = title
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        
        
        return navController
    }

}
