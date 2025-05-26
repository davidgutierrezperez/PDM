//
//  CoreDataStack.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import CoreData

final class CoreDataStack: ObservableObject {
    
    static let shared = CoreDataStack()
    
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AxelModel")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Error al cargar los datos de CoreData")
            }
        }
        
        return container
    }()
    
    func saveContext(){
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error al guardar los datos en CoreData")
        }
    }
    
}
