//
//  NoteRepository.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

final class NoteRepository: NoteRepositoryProtocol {
    
    private let context = CoreDataStack.shared.context
    
    func create(note: Note) {
        let noteEntity = NoteEntity(context: context)
        
        noteEntity.id = note.id
        noteEntity.title = note.title
        noteEntity.creationDate = note.creationDate
        noteEntity.lastModifiedSince = note.creationDate
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: note.content, requiringSecureCoding: false){
            noteEntity.content = data
        } else {
            print("❌ No se pudo guardar la nota \(note.title) en CoreData")
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func delete(id: UUID) {
        let fetchRequest = NoteRepository.fetchRequestByID(id: id, limit: 1)
        
        do {
            if let noteEntity = try context.fetch(fetchRequest).first {
                context.delete(noteEntity)
                CoreDataStack.shared.saveContext()
            } else {
                print("❌ No se pudo encontrar ninguna nota con ID \(id) en CoreData")
            }
        } catch {
            print("❌ No se pudo guardar la nota con ID \(id) de CoreData")
        }
        
    }
    
    func update(id: UUID, content: NSMutableAttributedString) {
        let fetchRequest = NoteRepository.fetchRequestByID(id: id, limit: 1)
        
        do {
            if let noteEntity = try context.fetch(fetchRequest).first,
               let data = try? NSKeyedArchiver.archivedData(withRootObject: content, requiringSecureCoding: false){
                noteEntity.content = data
                CoreDataStack.shared.saveContext()
            } else {
                print("❌ No se ha encontrado ninguna nota con ID \(id) en CoreData")
            }
        } catch {
            print("❌ No se ha encontrado actualizar la nota con ID \(id) en CoreData")
        }
    }
    
    func fetchAll() -> [Note] {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        do {
            let noteEntities = try context.fetch(fetchRequest)
            return noteEntities.map { Note(entity: $0) }
        } catch {
            print("❌ No se ha encontrado obtener las notas de CoreData")
        }
        
        
        return []
    }
    
    func fetchById(id: UUID) -> Note? {
        let fetchRequest = NoteRepository.fetchRequestByID(id: id, limit: 1)
        
        do {
            let note = try context.fetch(fetchRequest).first!
            return Note(entity: note)
        } catch {
            print("❌ No se ha podido obtener la nota con ID \(id) de CoreData")
        }
        
        return Note(title: "Error note")
    }
    
    func fetchNotesOfFolder(folderID: UUID) -> [Note] {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "folder.id == %@", folderID as CVarArg)
        
        do {
            let noteEntities = try context.fetch(fetchRequest)
            return noteEntities.map { Note(entity: $0) }
        } catch {
            print("❌ No se ha podido obtener las notas de la carpeta con ID \(folderID) de CoreData")
        }
        
        return []
    }
    
    func save(note: Note){
        let fetchRequest = NoteRepository.fetchRequestByID(id: note.id, limit: 1)
        
        let noteEntity: NoteEntity
        
        if let existing = try? context.fetch(fetchRequest).first {
            noteEntity = existing
        } else {
            noteEntity = NoteEntity(context: context)
            noteEntity.id = note.id
        }
        
        noteEntity.title = note.title
        noteEntity.content = try? NSKeyedArchiver.archivedData(withRootObject: note.content, requiringSecureCoding: false)
        
        CoreDataStack.shared.saveContext()
    }
    
    func rename(id: UUID, newTitle: String){
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            if let noteEntity = try context.fetch(fetchRequest).first {
                noteEntity.title = newTitle
            }
            
            CoreDataStack.shared.saveContext()
        } catch {
            print("❌ Nota con ID \(id) no encontrada")
        }
    }
    
    func duplicate(id: UUID, title: String){
        let fetchRequest = NoteRepository.fetchRequestByID(id: id, limit: 1)
        
        do {
            guard let noteEntity = try context.fetch(fetchRequest).first else {
                print("❌ Nota con ID \(id) no encontrada")
                return
            }
            
            let content: NSMutableAttributedString
            if let data = noteEntity.content,
               let attributedString = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as Data) as? NSMutableAttributedString {
                content = attributedString.mutableCopy() as? NSMutableAttributedString ?? NSMutableAttributedString(string: "")
            } else {
                content = NSMutableAttributedString(string: "")
            }
            
            let duplicateNote = Note(id: UUID(), content: content, title: title, lastModifiedSince: Date(), creationDate: Date())
            
            create(note: duplicateNote)
            
            if let folder = noteEntity.folder {
                addToFolder(noteID: duplicateNote.id, to: folder.id!)
            }
            
            CoreDataStack.shared.saveContext()
        } catch {
            print("❌ Nota con ID \(id) no encontrada")
        }
    }
    
    func addToFolder(noteID: UUID, to folderID: UUID){
        let noteFetchRequest = NoteRepository.fetchRequestByID(id: noteID, limit: 1)
        
        let folderFetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        folderFetchRequest.predicate = NSPredicate(format: "id == %@", folderID as CVarArg)
        folderFetchRequest.fetchLimit = 1
        
        do {
            guard let noteEntity = try context.fetch(noteFetchRequest).first else {
                print("❌ Nota con ID \(noteID) no encontrada")
                return
            }

            guard let folderEntity = try context.fetch(folderFetchRequest).first else {
                print("❌ Carpeta con ID \(folderID) no encontrada")
                return
            }
        
            noteEntity.folder = folderEntity
            
            CoreDataStack.shared.saveContext()
        } catch {
            print("❌ Error al asignar la nota con ID \(noteID) a la carpeta con ID \(folderID) en CoreData")
        }
    
    }
    
    func copyToOtherFolder(id: UUID, to folderID: UUID){
        let fetchRequest = NoteRepository.fetchRequestByID(id: id, limit: 1)
        
        do {
            guard let noteEntity = try context.fetch(fetchRequest).first else {
                print("❌ Nota con ID \(id) no encontrada")
                return
            }
            
            let content: NSMutableAttributedString
            if let data = noteEntity.content,
               let attributedString = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as Data) as? NSMutableAttributedString {
                content = attributedString.mutableCopy() as? NSMutableAttributedString ?? NSMutableAttributedString(string: "")
            } else {
                content = NSMutableAttributedString(string: "")
            }
            
            let duplicateNote = Note(id: UUID(), content: content, title: noteEntity.title!, lastModifiedSince: Date(), creationDate: Date())
            
            create(note: duplicateNote)
            addToFolder(noteID: duplicateNote.id, to: folderID)
            
            CoreDataStack.shared.saveContext()
        } catch {
            print("❌ Error al copiar la nota con ID \(id) no a la carpeta \(folderID)")
        }
    }
    
    private static func fetchRequestByID(id: UUID, limit: Int = Int.max) -> NSFetchRequest<NoteEntity> {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = limit
        
        return fetchRequest
    }
    
}
