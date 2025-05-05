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
    private(set) var isFiltering: Bool = false
    
    private(set) var folderID = UUID()
    
    private init(){}
    
    func setFolderID(id: UUID){
        folderID = id
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
        notes = noteRepository.fetchNotesOfFolder(folderID: id)
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
}
