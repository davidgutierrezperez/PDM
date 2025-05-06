//
//  NoteViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import Foundation

/// Clase que gestiona la información de una nota.
class NoteViewModel {
    
    /// Objeto que gestiona las consultas relacionadas con notas a CoreData.
    private let noteRepository = NoteRepository()
    
    /// Identificador de la nota.
    private(set) var id = UUID()
    
    /// Objeto que representa el modelo de la nota.
    private var note: Note
    
    /// Título de la nota.
    private var title: String { note.title }
    
    /// Contenido de la nota.
    private var content: NSMutableAttributedString { note.content }
    
    /// Constructor que gestiona la inicialización de una nota sin contenido alguno
    /// y la almacena en la base de datos.
    init() {
        note = Note(title: "Sin titulo")
        id = note.id
        
        saveNote()
    }
    
    /// Constructor que gestiona el establecimiento de los datos a partir de una
    /// nota ya creada.
    /// - Parameter note: objeto que representa una nota en el modelo.
    init(note: Note){
        self.note = note
        self.id = note.id
        
        saveNote()
    }
    
    /// Constructor que gestiona el establecimineto de los datos a partir de una
    /// nota ya creada y que ha sido añadia a una carpeta.
    /// - Parameters:
    ///   - note: objeto que representa una nota en el modelo.
    ///   - folderID: identificador de la carpeta en la que se encuentra la nota.
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
        noteRepository.save(note: note)
    }
    
    
    
}
