//
//  NoteListViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 28/4/25.
//

import Foundation

class NoteListViewModel {
    
    static let shared = NoteListViewModel()
    
    private let noteRepository = NoteRepository()
    
    private(set) var notes: [Note] = []
    private(set) var filteredNotes: [Note] = []
    private(set) var selectedNotes: Set<UUID> = []
    
    private(set) var isFiltering: Bool = false
    private(set) var isSelecting: Bool = false
    
    private(set) var folderID = UUID()
    private(set) var isAllFolder = false
    
    private init(){}
    
    func setFolderID(id: UUID){
        folderID = id
        isAllFolder = (id == UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
        
        if id == UUID(uuidString: "00000000-0000-0000-0000-000000000000"){
            print("Son iguales")
        } else {
            print("Son distintos")
        }
    }
    
    func createNote(title: String){
        let note = Note(title: title)
        
        noteRepository.create(note: note)
    }
    
    func fetchAll(){
        notes = noteRepository.fetchAll()
        filteredNotes = notes
    }
    
    func fetchNotesOfFolder(id: UUID){
        notes = (isAllFolder) ? noteRepository.fetchAll() : noteRepository.fetchNotesOfFolder(folderID: id)
        filteredNotes = notes
    }
    
    func numberOfNotes() -> Int {
        return isFiltering ? filteredNotes.count : notes.count
    }
    
    func note(at index: Int) -> Note {
        return isFiltering ? filteredNotes[index] : notes[index]
    }
    
    func delete(id: UUID){
        noteRepository.delete(id: id)
        notes.removeAll { $0.id == id } 
    }
    
    func rename(id: UUID, newTitle: String){
        noteRepository.rename(id: id, newTitle: newTitle)
    }
    
    func duplicate(id: UUID, title: String){
        noteRepository.duplicate(id: id, title: title)
    }
    
    func copyInOtherFolder(id: UUID, to folderID: UUID){
        noteRepository.copyToOtherFolder(id: id, to: folderID)
    }
    
    func filterNote(with searchText: String){
        if searchText.isEmpty {
            isFiltering = false
            filteredNotes = notes
        } else {
            isFiltering = true
            filteredNotes = notes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func isSelected(id: UUID) -> Bool {
        return selectedNotes.contains(id)
    }
    
    func toggleSelection(for id: UUID){
        if selectedNotes.contains(id){
            selectedNotes.remove(id)
            
            if selectedNotes.count == 0 { isSelecting = false }
        } else {
            selectedNotes.insert(id)
            isSelecting = true
        }
    }
    
    func setSelecting(_ isSelecting: Bool){
        self.isSelecting = isSelecting
        
        if (!isSelecting){
            fetchNotesOfFolder(id: folderID)
            clearSelection()
        }
    }
    
    func numberOfSelectedNotes() -> Int {
        return selectedNotes.count
    }
    
    func clearSelection(){
        selectedNotes.removeAll()
    }
    
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
