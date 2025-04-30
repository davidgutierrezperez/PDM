//
//  GeneralTabBar.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

class AlphabetumTabBar: UITabBarController {
    
    static let CreateNoteIcon = "square.and.pencil"
    static let FolderListIcon = "folder"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabs()
    }
    
    func configureTabs(){
        viewControllers = [setupFolderNavigationController(), setupNoteNavigationController()]
    }
    
    func createNavigationController(viewController: UIViewController, tabBarItem: UITabBarItem) -> UINavigationController {
        viewController.tabBarItem = tabBarItem
        viewController.tabBarItem.title = nil
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300)
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func createTabBarItem(_ image: UIImage!,_ tag: Int) -> UITabBarItem {
        let coloredImage = image.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        
        
        return UITabBarItem(title: nil, image: coloredImage, tag: tag)
    }
    
    private func setupNoteNavigationController() -> UINavigationController {
        let noteVC = NoteVC()
        let noteTabBarItem = createTabBarItem(UIImage(systemName: Self.CreateNoteIcon), 1)
        
        
        return createNavigationController(viewController: noteVC, tabBarItem: noteTabBarItem)
    }
    
    private func setupFolderNavigationController() -> UINavigationController {
        let createFolderVC = FolderListVC()
        let createFolderTabBarItem = createTabBarItem(UIImage(systemName: Self.FolderListIcon), 2)
        
        return createNavigationController(viewController: createFolderVC, tabBarItem: createFolderTabBarItem)
    }

}
