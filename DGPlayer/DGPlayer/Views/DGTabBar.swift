//
//  DGTabBar.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class DGTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    

    private func configure(){
        tabBar.backgroundColor = .systemFill
        tabBar.tintColor = .systemRed
        
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
    
    private func configureNavigationController(viewController: UIViewController, title: String, tabBarItem: UITabBarItem) -> UINavigationController {
        
        viewController.title = title
        viewController.tabBarItem = tabBarItem
        viewController.tabBarItem.title = title
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        
        
        return navController
    }

}
