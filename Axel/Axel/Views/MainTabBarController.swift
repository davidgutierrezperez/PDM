//
//  MainTabBarController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let activityListVC = ActivityListViewController()
    private let settingsVC = SettingsViewController()
    private let selectTrainingTypeVC = SelectTrainingTypeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = AppColors.background
        
        setupTabBarItems()
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewControllers()
    }
    
    private func setupViewControllers(){
        viewControllers = [UINavigationController(rootViewController: activityListVC),
                           UINavigationController(rootViewController: selectTrainingTypeVC)]
    }
    
    private func setupTabBarItems(){
        activityListVC.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: SFSymbols.home), tag: 0)
        selectTrainingTypeVC.tabBarItem = UITabBarItem(title: "Nueva actividad", image: UIImage(systemName: SFSymbols.add), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: SFSymbols.settings), tag: 2)
    }
    

}

