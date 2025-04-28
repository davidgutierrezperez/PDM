//
//  NoteListViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 28/4/25.
//

import Foundation

class NoteListViewModel {
    private let noteRepository = NoteRepository()
    
    private(set) var notes: [Note] = []
    private(set) var filteredNotes: [Note] = []
    private(set) var isFiltering: Bool = false
    
}
