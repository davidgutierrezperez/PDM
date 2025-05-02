//
//  NoteViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import Foundation

class NoteViewModel {
    
    private let noteRepository = NoteRepository()
    
    private(set) var id = UUID()
    private var note: Note
    private var title: String { note.title }
    private var content: NSMutableAttributedString { note.content }
    
    init() {
        note = Note(title: "Sin titulo")
        id = note.id
        
        saveNote()
    }
    
    init(note: Note){
        self.note = note
        self.id = note.id
        
        saveNote()
    }
    
    convenience init(note: Note, folderID: UUID){
        self.init(note: note)
        
        saveNote()
        addToFolder(folderID: folderID)
    }
    
    func updateTitle(_ newTitle: String){
        note.title = newTitle
        saveNote()
    }
    
    func updateContent(_ newContent: NSMutableAttributedString){
        note.content = newContent
        saveNote()
    }
    
    func getNote() -> Note {
        return note
    }
    
    func addToFolder(folderID: UUID){
        noteRepository.addToFolder(noteID: note.id, to: folderID)
    }
    
    func saveNote(){
        print("El nuevo título es: ", note.title)
        noteRepository.save(note: note)
    }
    
}
