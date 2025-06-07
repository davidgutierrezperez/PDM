//
//  CoreDataStack.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import CoreData

/// Clase que representa el motor de almacenamiento de CoreData.
final class CoreDataStack: ObservableObject {
    
    /// Instancia única de la clase.
    static let shared = CoreDataStack()
    
    /// Constructor por defecto de la clase. Al ser un singleton, se impide
    /// instanciar un objeto de la clase.
    private init(){}
    
    /// Contenedor que representa el motor de almacenamiento de CoreData.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AxelModel")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Error al cargar los datos de CoreData")
            }
        }
        
        return container
    }()
    
    /// Permite llevar a cabo acciones sobre CoreData.
    func saveContext(){
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error al guardar los datos en CoreData")
        }
    }
    
}
