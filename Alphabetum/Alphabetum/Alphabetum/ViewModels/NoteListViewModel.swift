//
//  NoteListViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 28/4/25.
//

import Foundation

/// Clase que gestiona la información almacenada en una lista de notas.
final class NoteListViewModel {
    
    /// Instancia única de la clase.
    static let shared = NoteListViewModel()
    
    /// Objeto que gestiona las consultas relacionadas con notas en CoreData.
    private let noteRepository = NoteRepository()
    
    /// Array de notas a mostrar en una lista o tabla.
    private(set) var notes: [Note] = []
    
    /// Array de notas filtradas a mostrar en una lista o tabla.
    private(set) var filteredNotes: [Note] = []
    
    /// Array de notas selecciondas.
    private(set) var selectedNotes: Set<UUID> = []
    
    /// Variable que indica si se está filtrando notas.
    private(set) var isFiltering: Bool = false
    
    /// Variable que indica si se están seleccionando notas.
    private(set) var isSelecting: Bool = false
    
    /// Identificador de la carpeta en la que se muestran las notas
    /// de la lista o tabla.
    private(set) var folderID = UUID()
    
    /// Variable que indica si la carpeta en la que se muestran las notas
    /// es la carpeta virtual llamada 'All'.
    private(set) var isAllFolder = false
    
    /// Constructor privado de la clase que impide que se instancia la clase.
    private init(){}
    
    /// Permite establecer el identificador de la carpeta en la que se muestran
    /// las notas.
    /// - Parameter id: identificador de la carpeta.
    func setFolderID(id: UUID){
        folderID = id
        isAllFolder = (id == UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
        
        if id == UUID(uuidString: "00000000-0000-0000-0000-000000000000"){
            print("Son iguales")
        } else {
            print("Son distintos")
        }
    }
    
    /// Indica si se puede crear una nota.
    /// - Parameter title: título de la nota a crear.
    /// - Returns: un booleano con valor **True** si se puede crear
    /// la nota y **false** en caso contrario.
    func canCreateNote(with title: String) -> Bool {
        return noteRepository.noteTitleExist(title)
    }
    
    /// Crea una nota si es posible.
    /// - Parameter title: título de la nota a crear.
    /// - Returns: un booleano con valor **True** si se puede crear
    /// la nota y **false** en caso contrario.
    func createNoteIfPossible(title: String) -> Bool {
        guard canCreateNote(with: title) else { return false }
        
        noteRepository.create(note: Note(title: title))
        return true
    }
    
    /// Crea una nota y la almacena en la base de datos.
    /// - Parameter title: título de la nota crear.
    func createNote(title: String){
        let note = Note(title: title)
        
        noteRepository.create(note: note)
    }
    
    /// Obtiene todas las notas almacendas en la base de datos.
    func fetchAll(){
        notes = noteRepository.fetchAll()
        filteredNotes = notes
    }
    
    /// Obtiene todas las notas de una determinada carpeta.
    /// - Parameter id: identificador de la carpeta.
    func fetchNotesOfFolder(id: UUID){
        notes = (isAllFolder) ? noteRepository.fetchAll() : noteRepository.fetchNotesOfFolder(folderID: id)
        filteredNotes = notes
    }
    
    /// Comprueba si alguna nota tiene el título pasado como argumento.
    /// - Parameter title: título a comprobar.
    /// - Returns: un booleano con valor **True** si ya existe una nota
    /// con ese título y **False** en caso contrario.
    func titleExist(title: String) -> Bool {
        return noteRepository.noteTitleExist(title)
    }
    
    /// Número de notas en la lista o tabla.
    /// - Returns: un entero con el número de notas.
    func numberOfNotes() -> Int {
        return isFiltering ? filteredNotes.count : notes.count
    }
    
    /// Devuelve una nota a partir de su índice en la lista o tabla.
    /// - Parameter index: índice de la nota en la lista o tabla.
    /// - Returns: un objeto de tipo Note.
    func note(at index: Int) -> Note {
        return isFiltering ? filteredNotes[index] : notes[index]
    }
    
    /// Elimina una nota, tanto de la carpeta como de la aplicación.
    /// - Parameter id: identificador de la nota a eliminar.
    func delete(id: UUID){
        noteRepository.delete(id: id)
        notes.removeAll { $0.id == id } 
    }
    
    /// Renombra una nota con un nuevo título.
    /// - Parameters:
    ///   - id: identificador de la nota.
    ///   - newTitle: nuevo título de la nota.
    func rename(id: UUID, newTitle: String){
        noteRepository.rename(id: id, newTitle: newTitle)
    }
    
    /// Duplica una nota con un nuevo título.
    /// - Parameters:
    ///   - id: identificador de la nota a duplicar.
    ///   - title: título de la nueva nota.
    func duplicate(id: UUID, title: String){
        noteRepository.duplicate(id: id, title: title)
    }
    
    /// Copia una nota en otra carpeta.
    /// - Parameters:
    ///   - id: identificador de la nota a copiar.
    ///   - folderID: identificador de la carpeta en la que será copiada la nota.
    func copyInOtherFolder(id: UUID, to folderID: UUID){
        noteRepository.copyToOtherFolder(id: id, to: folderID)
    }
    
    /// Filtra las notas según un texto de búsqueda.
    /// - Parameter searchText: texto de búsqueda.
    func filterNote(with searchText: String){
        if searchText.isEmpty {
            isFiltering = false
            filteredNotes = notes
        } else {
            isFiltering = true
            filteredNotes = notes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    /// Indica si una nota ha sido seleccionada.
    /// - Parameter id: identificador de una nota.
    /// - Returns: un booleano con un valor de **True** si la nota ha sido
    /// seleccionada y **False** en caso contrario.
    func isSelected(id: UUID) -> Bool {
        return selectedNotes.contains(id)
    }
    
    /// Cambia el estado de la selección de una nota.
    /// - Parameter id: identificador de la nota.
    func toggleSelection(for id: UUID){
        if selectedNotes.contains(id){
            selectedNotes.remove(id)
            
            if selectedNotes.count == 0 { isSelecting = false }
        } else {
            selectedNotes.insert(id)
            isSelecting = true
        }
    }
    
    /// Establece la selección de una nota.
    /// - Parameter isSelecting: booleano que indica si se establece la selección.
    func setSelecting(_ isSelecting: Bool){
        self.isSelecting = isSelecting
        
        if (!isSelecting){
            fetchNotesOfFolder(id: folderID)
            clearSelection()
        }
    }
    
    /// Número de notas seleccionadas.
    /// - Returns: entero con el número de notas seleccionadas.
    func numberOfSelectedNotes() -> Int {
        return selectedNotes.count
    }
    
    /// Elimina toda la selección de notas.
    func clearSelection(){
        selectedNotes.removeAll()
    }
    
    /// Elimina las notas selecciondas.
    func deleteSelectedNotes(){
        guard isSelecting else { return }
        
        if selectedNotes.isEmpty {
            for note in notes {
                delete(id: note.id)
            }
        } else {
            for id in selectedNotes {
                delete(id: id)
            }
        }
    }
}
