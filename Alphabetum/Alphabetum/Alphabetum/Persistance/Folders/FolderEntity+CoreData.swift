//
//  Folder+CoreData.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

/// Extension que maneja la creación de una nota
/// y su manejo con información proveniente de CoreData
extension Folder {
    
    /// Constructor que permite generar una Carpeta a partir
    /// de la información proporcionada por CoreData.
    /// - Parameter entity: entidad que representa una carpeta en CoreData.
    init(entity: FolderEntity){
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        
        if let notesSet = entity.notes as? NSSet {
            self.notes = notesSet
                .compactMap { $0 as? NoteEntity }
                .map { Note(entity: $0) }
        } else {
            self.notes = []
        }
        
    }
    
    /// Constructor que permite generar una Carpeta totalmente vacía.
    /// - Parameters:
    ///   - id: identificador de la Carpeta.
    ///   - title: título de la carpeta.
    init(id: UUID = UUID(), title: String){
        self.id = id
        self.title = title
        self.notes = []
    }
}
