//
//  FolderRepositoryProtocol.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

protocol FolderRepositoryProtocol {
    func createFolder(folder: Folder)
    func deleteFolder(id: UUID)
    func fetchAllFolders() -> [Folder]
}
