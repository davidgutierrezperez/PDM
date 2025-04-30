//
//  NoteViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import Foundation

class NoteViewModel {
    private(set) var id = UUID()
    private var note: Note
    private var title: String { note.title }
    private var content: NSMutableAttributedString { note.content }
    
    init() {
        note = Note(title: "Sin titulo")
        id = note.id
    }
    
    init(note: Note){
        self.note = note
        self.id = note.id
    }
    
    func updateTitle(_ newTitle: String){
        note.title = newTitle
    }
    
    func updateContent(_ newContent: NSMutableAttributedString){
        note.content = newContent
    }
    
    func getNote() -> Note {
        return note
    }
    
    
}
