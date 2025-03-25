//
//  FavoritesVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class FavoritesVC: SongsVC {
    
    static var songs: [Song] = []
    
    override init(){
        super.init()
        
        FavoritesVC.songs = FileManagerHelper.loadFavouriteSongsFromCoreData()
        tableView.setSongs(songs: FavoritesVC.songs)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if (tableView.songs != FavoritesVC.songs){
            tableView.setSongs(songs: FavoritesVC.songs)
            tableView.tableView.reloadData()
        }
 
    }

}
