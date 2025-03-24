//
//  FavoritesVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class FavoritesVC: SongsVC {
    
    private var songs: [Song] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        songs = FileManagerHelper.loadFavouriteSongsFromCoreData()
        tableView.setSongs(songs: self.songs)

        isSearchEnable = false
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
        
        configureTableView()
    }
    
    override func deleteSong(at index: Int){
        let song = tableView.songs[index]
        
        tableView.songs.remove(at: index)
        tableView.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        
        FileManagerHelper.addSongToFavourites(title: song.title!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        songs = FileManagerHelper.loadFavouriteSongsFromCoreData()
        tableView.setSongs(songs: songs)
    }

}
