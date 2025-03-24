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
        tableView.tableView.delegate = self
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
        addTargetToButton(boton: addButton, target: self, action: #selector(addPlaylist))

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

   

}

extension PlaylistVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let playlist = self.tableView.playlists[indexPath.item]
        
        let songs = FileManagerHelper.loadSongsFromCoreData()
        
        let songVC = PlaylistSongsVC(playlist: playlist, songs: songs)
        songVC.setSongs(songs: songs)
        
        print("EL NÚMERO DE CANCIONES es: ", songs.count)
        
        songVC.title = playlist.name
        print(songs)
        
        navigationController?.pushViewController(songVC, animated: true)
    }
}
