//
//  FavoritesVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class FavoritesVC: SongsVC {
    
    var songs: [Song] = FavoritesManager.shared.songs
    
    
    override init(){
        super.init()
        
        tableView.setSongs(songs: songs)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureButtons()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        songs = FavoritesManager.shared.songs
        
        if (tableView.songs != songs){
            tableView.setSongs(songs: songs)
            tableView.tableView.reloadData()
        }
    }
    
    
    override func deleteSong(at index: Int){
        let song = tableView.songs[index]
        
        tableView.songs.remove(at: index)
        tableView.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        
        FileManagerHelper.addSongToFavourites(title: song.title!)
    }
    
    private func configureButtons(){
        navigationItem.rightBarButtonItem = addButton
        
        addTargetToBarButton(boton: addButton, target: self, action: #selector(addSongToFavorites))
    }
    
    @objc private func addSongToFavorites(){
        let songSelectorVC = SongSelectorVC()
        
        songSelectorVC.onSongSelected = { [weak self] newSong in
            guard let self = self else { return }
            tableView.addSong(song: newSong)
        }
        
        let nv = UINavigationController(rootViewController: songSelectorVC)
        present(nv, animated: true)
    }
    

}
