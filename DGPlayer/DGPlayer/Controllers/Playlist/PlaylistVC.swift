//
//  PlaylistVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class PlaylistVC: MainViewsCommonVC {
    
    private var playlists: [Playlist] = []
    private var tableView: DGPlaylistTableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlists = FileManagerHelper.loadPlaylistsFromCoreData()
        tableView = DGPlaylistTableView(playlists: playlists)
        tableView.delegate = self
        tableView.tableView.delegate = self
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
        addTargetToButton(boton: addButton, target: self, action: #selector(addPlaylist))
        
        navigationItem.searchController = configureSearchController()
        navigationItem.hidesSearchBarWhenScrolling = false

        view.backgroundColor = .systemBackground
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc private func addPlaylist(){
        let addPlaylistVC = PlaylistCreationVC(placeholder: "Playlist title")
        let navVC = UINavigationController(rootViewController: addPlaylistVC)
        
        addPlaylistVC.onPlaylistCreated = { [weak self] in
            guard let self = self else { return }
            self.playlists = FileManagerHelper.loadPlaylistsFromCoreData()
            self.tableView.setPlaylist(playlists: self.playlists)
            self.tableView.tableView.reloadData()
        }
        
        self.present(navVC, animated: true)
    }
    
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
    
    private func configureSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a song"
        
        return searchController
    }
    
    private func deletePlaylistFromCoreData(at index: Int){
        let title = tableView.playlists[index].name
        FileManagerHelper.deletePlaylistFromCoreData(playlistTitle: title)
        
        tableView.playlists.remove(at: index)
        tableView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension PlaylistVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let playlist = self.tableView.playlists[indexPath.item]
        
        let songs = FileManagerHelper.loadSongsOfPlaylistFromCoreData(name: playlist.name)
        
        let songVC = PlaylistSongsVC(playlist: playlist, songs: songs)
        songVC.setSongs(songs: songs)
        
        songVC.title = playlist.name
        navigationController?.pushViewController(songVC, animated: true)
    }
}

extension PlaylistVC: DGPlaylistTableViewDelegate {
    func deletePlaylist(at index: Int) {
        self.deletePlaylistFromCoreData(at: index)
    }
}

extension PlaylistVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            tableView.tableView.reloadData()
            return
        }
        
        let filteredPlaylists = tableView.playlists.filter { $0.name.lowercased().contains(filter) }
        tableView.setFilteredPlaylists(playlists: filteredPlaylists)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.setPlaylist(playlists: tableView.playlists)
        tableView.tableView.reloadData()
    }
}


