//
//  NoteRepository.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

final class NoteRepository: NoteRepositoryProtocol {
    private let context = CoreDataStack.shared.context
    
    func createNote(note: Note) {
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
    
    func deleteNote(id: UUID) {
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
    
    func updateNote(id: UUID, content: NSMutableAttributedString) {
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
    
    func fetchAllNotes() -> [Note] {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        do {
            let notes = try context.fetch(fetchRequest) as! [Note]
            return notes
        } catch {
            print("❌ No se ha encontrado obtener las notas de CoreData")
        }
        
        
        return []
    }
}
