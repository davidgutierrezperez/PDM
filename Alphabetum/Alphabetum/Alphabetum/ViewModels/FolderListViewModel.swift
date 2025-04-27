//
//  FolderListViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

final class FolderListViewModel {
    
    private let folderRepository = FolderRepository()
    private(set) var folders: [Folder] = []
    
    func createFolder(title: String){
        folderRepository.createFolder(folder: Folder(title: title))
    }
    
    func numberOfFolders() -> Int {
        return folders.count
    }
    
    func fetchFolders() {
        folders = folderRepository.fetchAllFolders()
    }
    
    func folder(at index: Int) -> Folder {
        return folders[index]
    }
}
