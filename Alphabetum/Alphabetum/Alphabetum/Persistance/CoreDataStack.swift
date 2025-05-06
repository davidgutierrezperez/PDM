//
//  CoreDataStack.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

/// Clase que representa el motor de CoreData.
final class CoreDataStack {
    
    /// Instancia única de la clase que permite acceder a CoreData.
    static let shared = CoreDataStack()
    
    /// Contenedor que permite acceder a un modelo en concreto de CoreData.
    let persistentContainer: NSPersistentContainer
    
    /// Objeto que permite acceder al modelo de la base de datos de CoreData.
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// Constructor privado que inicializa la instancia única de la clase y que
    /// inicializa el motor de CoreData.
    private init(){
        persistentContainer = NSPersistentContainer(name: "AlphabetumModel")
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error)")
            }

            
        }
    }
    
    /// Actualiza la base de datos de CoreData.
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
