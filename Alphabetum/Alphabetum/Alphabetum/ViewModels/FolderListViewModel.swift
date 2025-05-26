//
//  FolderListViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

/// Clase que gestiona la información almacenada con
/// listas de Carpetas.
final class FolderListViewModel {
    
    /// Instancia única de la clase.
    static let shared = FolderListViewModel()
    
    /// Objeto que gestiona las consultas relacionadas con Carpetas.
    private let folderRepository = FolderRepository()
    
    /// Array de carpetas a mostrar en una lista.
    private(set) var folders: [Folder] = []
    
    /// Array de carpetas filtradas en una lista.
    private(set) var filteredFolders: [Folder] = []
    
    /// Indica si se está filtrando por carpetas.
    private(set) var isFiltering: Bool = false
    
    /// Indica si se ha llevado a cabo cambios en la información almacenda.
    var hasChanged: Bool = false
    
    /// Carpeta virtual que contiene todas las notas de la aplicación.
    private let allFolder = Folder(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "All")
    
    /// Crea una carpeta y llama a *FolderRepository* para que lo almacene en
    /// la base de datos.
    /// - Parameter title: título de la carpeta.
    func createFolder(title: String){
        let newFolder = Folder(title: title)
        
        folderRepository.createFolder(folder: newFolder)
    }
    
    /// Número de carpetas mostradas en una lista.
    /// - Returns: un entero con el número de carpetas.
    func numberOfFolders() -> Int {
        let baseCount = isFiltering ? filteredFolders.count : folders.count
        return baseCount + 1
    }
    
    /// Devuelve todas las carpetas almacenadas en la aplicación.
    func fetchFolders() {
        folders = folderRepository.fetchAllFolders()
        filteredFolders = folders
    }
    
    /// Permite eliminar una carpeta.
    /// - Parameter id: identificador de la carpeta a eliminar.
    func delete(id: UUID){
        folderRepository.deleteFolder(id: id)
        folders.removeAll { $0.id == id }
        
        if isFiltering {
            filteredFolders.removeAll { $0.id == id }
        }
    }
    
    /// Devuelve una carpeta a partir de su índice en una
    /// lista o una tabla.
    /// - Parameter index: índice de la carpeta en una tabla o lista.
    /// - Returns: un objeto de tipo Folder.
    func folder(at index: Int) -> Folder {
        if index == 0 {
            return Folder(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "All")
        } else {
            return isFiltering ? filteredFolders[index - 1] : folders[index - 1]
        }
    }
    
    /// Permite renombrar una carpeta con un nuevo título.
    /// - Parameters:
    ///   - id: identificador de la carpeta.
    ///   - newTitle: nuevo título de la carpeta.
    func renameFolder(id: UUID, newTitle: String){
        folderRepository.renameFolder(id: id, newTitle: newTitle)
    }
    
    /// Permite filtrar carpetas a partir de un texto de búsqueda.
    /// - Parameter searchText: texto de búsqueda para filtrar carpetas.
    func filterFolders(with searchText: String){
        if searchText.isEmpty {
            isFiltering = false
            filteredFolders = folders
        } else {
            isFiltering = true
            filteredFolders = folders.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func numberOfAllFolders() -> Int {
        let notes = folderRepository.fetchAllFolders()
        return notes.count
    }
    
    func folderExists(title: String) -> Bool {
        let folderTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return folderRepository.titleExist(title: folderTitle)
    }
}
