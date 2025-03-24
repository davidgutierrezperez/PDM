//
//  SongSelectorVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

class SongSelectorVC: SongsVC {
    
    private let cancelButton = UIBarButtonItem()
    private let playlistTitle: String
    
    var onSongSelected: ((Song) -> Void)?
    
    init(playlistTitle: String){
        self.playlistTitle = playlistTitle
        
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
        
        configureTableView()
    }
    
    private func configureButtons(){
        cancelButton.title = "Cancel"
        cancelButton.tintColor = .systemRed
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = self.tableView.songs[indexPath.row]
        FileManagerHelper.addSongToPlaylist(playlistTitle: playlistTitle, song: song)
        
        onSongSelected?(song)
        
        dismiss(animated: true)
    }
    
    
}
