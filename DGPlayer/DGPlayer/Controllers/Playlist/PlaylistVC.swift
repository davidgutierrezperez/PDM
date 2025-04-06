//
//  PlaylistVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

/// Controlador que maneja la lista de *playlists* y sus eventos asociados.
class PlaylistVC: MainViewsCommonVC {
    
    /// Tabla con la lista de *playlists* almacenadas
    var tableView: DGPlaylistTableView!
    
    
    /// Eventos a ocurrir cuando la vista carga por primera vez
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playlists = FileManagerHelper.loadPlaylistsFromCoreData()
        
        tableView = DGPlaylistTableView(playlists: playlists)
        tableView.delegate = self
        tableView.tableView.delegate = self
        
        configureNavigationItems()

        view.backgroundColor = .systemBackground
        
        configure()
    }
    
    /// Muestra el controlador de creación de playlists para poder añadir una *playlist*.
    @objc private func addPlaylist(){
        let addPlaylistVC = PlaylistCreationVC(placeholder: "Playlist title")
        let navVC = UINavigationController(rootViewController: addPlaylistVC)
        
        addPlaylistVC.onPlaylistCreated = { [weak self] in
            guard let self = self else { return }
            let playlists = FileManagerHelper.loadPlaylistsFromCoreData()
            self.tableView.setPlaylist(playlists: playlists)
            self.tableView.tableView.reloadData()
        }
        
        self.present(navVC, animated: true)
    }
    
    /// Configura los botones que se muestran en la vista a excepción de los
    /// incluidos en el TabBar.
    private func configureButtons(){
        navigationItem.rightBarButtonItems = [addButton]
        addTargetToBarButton(boton: addButton, target: self, action: #selector(addPlaylist))
    }
    
    /// Configura los elementos de navigación de la vista.
    private func configureNavigationItems(){
        configureButtons()
        
        navigationItem.searchController = configureSearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    /// Configura la vista asociada en el controlador.
    private func configure(){
        view.addSubview(tableView.tableView)
        
        tableView.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Configura el controlador de búsqueda.
    /// - Returns: devuelve un controlador de búsqueda previamente configurado.
    private func configureSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a playlist"
        
        return searchController
    }
    
    /// Elimina una *playlist* de *Core Data*.
    /// - Parameter index: índice de la *playlist* a eliminar en la tabla de *playlists*.
    private func deletePlaylistFromCoreData(at index: Int){
        let title = tableView.playlists[index].name
        FileManagerHelper.deletePlaylistFromCoreData(playlistTitle: title)
        
        tableView.playlists.remove(at: index)
        tableView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension PlaylistVC: UITableViewDelegate {
    
    /// Permite abrir el controlador asociado a una *playist* seleccionada.
    /// - Parameters:
    ///   - tableView: tabla con la lista de *playlists* almacenadas en la aplicación.
    ///   - indexPath: índice de la *playlist* seleccionada.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let playlist = self.tableView.playlists[indexPath.item]
        
        let songVC = PlaylistSongsVC(playlist: playlist)
        
        songVC.title = playlist.name
        navigationController?.pushViewController(songVC, animated: true)
    }
}

extension PlaylistVC: DGPlaylistTableViewDelegate {
    /// Elimina una *playlist* seleccionada.
    /// - Parameter index: índice de la *playlist* a eliminar en la tabla de *playlists*.
    func deletePlaylist(at index: Int) {
        self.deletePlaylistFromCoreData(at: index)
    }
}

extension PlaylistVC: UISearchResultsUpdating, UISearchBarDelegate {
    /// Actualiza los resultados en la tabla de *playlists* en función de la búsqueda realizada mediante
    /// el controlador de búsqueda.
    /// - Parameter searchController: controlador de búsqueda utilizado.
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            tableView.tableView.reloadData()
            return
        }
        
        let filteredPlaylists = tableView.playlists.filter { $0.name.lowercased().contains(filter) }
        tableView.setFilteredPlaylists(playlists: filteredPlaylists)
    }
    
    /// Reestablece la tabla de *playlists* cuando se cancela la búsqueda en el
    /// controlador de búsqueda.
    /// - Parameter searchBar: controlador de búsqueda utilizado.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.setPlaylist(playlists: tableView.playlists)
        tableView.tableView.reloadData()
    }
}


