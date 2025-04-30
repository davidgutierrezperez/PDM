//
//  FolderRepository.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

final class FolderRepository: FolderRepositoryProtocol {
    private let context = CoreDataStack.shared.context
    
    func createFolder(folder: Folder) {
        let folderEntity = FolderEntity(context: context)
        
        folderEntity.id = folder.id
        folderEntity.title = folder.title
        
        CoreDataStack.shared.saveContext()
    }
    
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
