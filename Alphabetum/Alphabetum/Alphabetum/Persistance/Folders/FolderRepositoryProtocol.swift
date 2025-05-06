//
//  FolderRepositoryProtocol.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

/// Protocolo que representa todas las funciones que deberá tener
/// la clase FolderRepository.
protocol FolderRepositoryProtocol {
    func createFolder(folder: Folder)
    func deleteFolder(id: UUID)
    func fetchAllFolders() -> [Folder]
}
