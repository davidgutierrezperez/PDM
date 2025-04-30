//
//  CoreDataStack.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "AlphabetumModel")
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error)")
            }

            
        }
    }
    
    func saveContext(){
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("✅️ Se ha guardado con éxito")
            } catch {
                let error = error as NSError
                fatalError("❌ Error saving Core Data context: \(error)")
            }
        }
    }
}
