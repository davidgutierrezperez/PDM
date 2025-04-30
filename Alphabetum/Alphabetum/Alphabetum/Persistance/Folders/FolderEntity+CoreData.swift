//
//  Folder+CoreData.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

extension Folder {
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
    
    init(id: UUID = UUID(), title: String){
        self.id = UUID()
        self.title = title
        self.notes = []
    }
}
