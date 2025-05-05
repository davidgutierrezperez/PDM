//
//  FolderListViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

final class FolderListViewModel {
    
    static let shared = FolderListViewModel()
    
    private let folderRepository = FolderRepository()
    
    private(set) var folders: [Folder] = []
    private(set) var filteredFolders: [Folder] = []
    private(set) var isFiltering: Bool = false
    
    var hasChanged: Bool = false
    
    private let allFolder = Folder(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "All")
    
    func createFolder(title: String){
        let newFolder = Folder(title: title)
        
        folderRepository.createFolder(folder: newFolder)
    }
    
    func numberOfFolders() -> Int {
        let baseCount = isFiltering ? filteredFolders.count : folders.count
        return baseCount + 1
    }
    
    func fetchFolders() {
        folders = folderRepository.fetchAllFolders()
        filteredFolders = folders
    }
    
    func delete(id: UUID){
        folderRepository.deleteFolder(id: id)
        folders.removeAll { $0.id == id }
        
        if isFiltering {
            filteredFolders.removeAll { $0.id == id }
        }
    }
    
    func folder(at index: Int) -> Folder {
        if index == 0 {
            return Folder(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "All")
        } else {
            return isFiltering ? filteredFolders[index - 1] : folders[index - 1]
        }
    }
    
    func renameFolder(id: UUID, newTitle: String){
        folderRepository.renameFolder(id: id, newTitle: newTitle)
    }
    
    func filterFolders(with searchText: String){
        if searchText.isEmpty {
            isFiltering = false
            filteredFolders = folders
        } else {
            isFiltering = true
            filteredFolders = folders.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
}
