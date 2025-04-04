//
//  SongSelectorVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

enum ADD_ACTION {
    case ADD_TO_FAVORITES
    case ADD_TO_PLAYIST
}

class SongSelectorVC: SongsVC {
    
    private let cancelButton = UIBarButtonItem()
    private let playlistTitle: String
    private let addAction: ADD_ACTION
    
    var onSongSelected: ((Song) -> Void)?
    
    init(playlistTitle: String){
        self.playlistTitle = playlistTitle
        addAction = ADD_ACTION.ADD_TO_PLAYIST
        
        super.init()
        
        let songsToSelect = FileManagerHelper.loadSongsFromCoreData()
        tableView = DGSongTableView(songs: songsToSelect)
    }
    
    override init(){
        playlistTitle = ""
        addAction = ADD_ACTION.ADD_TO_FAVORITES
        
        super.init()
        
        let songsToSelect = FileManagerHelper.loadSongsFromCoreData()
        tableView = DGSongTableView(songs: songsToSelect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        configureButtons()
        
        configureTableView()
    }
    
    private func configureButtons(){
        cancelButton.title = "Cancel"
        cancelButton.tintColor = .systemRed
        
        navigationItem.leftBarButtonItem = cancelButton
        
        addTargetToBarButton(boton: cancelButton, target: self, action: #selector(dismissVC))
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = (!self.tableView.isFiltering) ?
                    self.tableView.songs[indexPath.row] :
                    self.tableView.filteredSongs[indexPath.row]
        
        if (addAction == ADD_ACTION.ADD_TO_PLAYIST){
            FileManagerHelper.addSongToPlaylist(playlistTitle: playlistTitle, song: song)
        } else {
            FileManagerHelper.addSongToFavourites(title: song.title!)
        }
        
        onSongSelected?(song)
        
        navigationItem.searchController?.isActive = false
        dismiss(animated: true)
    }
    
    override func deleteSong(at index: Int) {}
    
}
