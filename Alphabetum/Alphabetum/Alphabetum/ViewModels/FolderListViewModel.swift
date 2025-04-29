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
    
    private init(){}
    
    func createFolder(title: String){
        let newFolder = Folder(title: title)
        
        folderRepository.createFolder(folder: newFolder)
    }
    
    func numberOfFolders() -> Int {
        return isFiltering ? filteredFolders.count : folders.count
    }
    
    func fetchFolders() {
        folders = folderRepository.fetchAllFolders()
        filteredFolders = folders
    }
    
    func deleteFolder(){
        
    }
    
    func folder(at index: Int) -> Folder {
        return isFiltering ? filteredFolders[index] : folders[index]
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
