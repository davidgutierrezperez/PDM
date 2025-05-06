//
//  FolderRepository.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

/// Clase que gestiona las consultas realizadas a CoreData.
final class FolderRepository: FolderRepositoryProtocol {
    
    /// Contexto que permite acceder a la base de datos de CoreData.
    private let context = CoreDataStack.shared.context
    
    /// Crea una carpeta y la almacena en la base de datos de CoreData.
    /// - Parameter folder: carpeta a almacenar.
    func createFolder(folder: Folder) {
        let folderEntity = FolderEntity(context: context)
        
        folderEntity.id = folder.id
        folderEntity.title = folder.title
        
        CoreDataStack.shared.saveContext()
    }
    
    /// Elimina una carpeta de la base de datos de CoreData a partir de
    /// su identificador.
    /// - Parameter id: identificador de la carpeta.
    func deleteFolder(id: UUID) {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            if let folder = try context.fetch(fetchRequest).first {
                context.delete(folder)
                CoreDataStack.shared.saveContext()
            } else {
                print("❌ No se ha podido encontrar una carpeta con ID \(id) en CoreData")
            }
        } catch {
            print("❌ No se ha podido borrar la carpeta con ID \(id) de CoreData")
        }
    }
    
    /// Permite renombrar una carpeta con un nuevo título.
    /// - Parameters:
    ///   - id: identificador de la carpeta a renombrar.
    ///   - newTitle: nuevo título de la carpeta.
    func renameFolder(id: UUID, newTitle: String){
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            if let folderEntity = try context.fetch(fetchRequest).first {
                folderEntity.title = newTitle
            }
        
            CoreDataStack.shared.saveContext()
        } catch {
            print("❌ No se han podido obtener las carpetas almacenadas en CoreData")
        }
    }
    
    /// Devuelve todas las carpetas almacenadas en el sistema.
    /// - Returns: un array de objetos Folder con todos las carpetas almacenadas.
    func fetchAllFolders() -> [Folder] {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        
        do {
            let folderEntities = try context.fetch(fetchRequest)
            return folderEntities.map { Folder(entity: $0) }
        } catch {
            print("❌ No se han podido obtener las carpetas almacenadas en CoreData")
        }
        
        return []
    }
    
}
