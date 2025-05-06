//
//  NoteRepositoryProtocol.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

/// Protocolo que representa las funciones que tendrá la clase **NoteRepository**
protocol NoteRepositoryProtocol {
    func create(note: Note)
    func delete(id: UUID)
    func update(id: UUID, content: NSMutableAttributedString)
    func fetchNotesOfFolder(folderID: UUID) -> [Note]
    func fetchAll() -> [Note]
    func fetchById(id: UUID) -> Note?
}
