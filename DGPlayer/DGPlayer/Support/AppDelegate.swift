//
//  AppDelegate.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SongModel") // Asegúrate de usar el mismo nombre que tu .xcdatamodeld
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("❌ Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var persistentContainerPlaylist: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlayListModel") // Asegúrate de usar el mismo nombre que tu .xcdatamodeld
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("❌ Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Datos guardados en Core Data")
            } catch {
                let error = error as NSError
                fatalError("❌ Error al guardar en Core Data: \(error), \(error.userInfo)")
            }
        }
    }
}

extension UIApplication {
    static func topMostViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                                        .first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            return topMostViewController(base: tab.selectedViewController)
        }

        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }

        return base
    }
}


