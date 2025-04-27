//
//  NoteRepositoryProtocol.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

protocol NoteRepositoryProtocol {
    func createNote(note: Note)
    func deleteNote(id: UUID)
    func updateNote(id: UUID, content: NSMutableAttributedString)
    func fetchAllNotes() -> [Note]
}
