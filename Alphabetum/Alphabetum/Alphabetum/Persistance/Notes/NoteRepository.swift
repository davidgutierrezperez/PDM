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
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
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
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
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
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %id", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
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
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        fetchRequest.fetchLimit = 1
        
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
    
}
