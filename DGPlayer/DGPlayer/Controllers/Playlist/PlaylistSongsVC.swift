//
//  PlaylistSongsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

class PlaylistSongsVC: SongsVC {
    
    private let playlistSettingButton = UIBarButtonItem()
    private var playlist: Playlist
    
    init(playlist: Playlist, songs: [Song]){
        
        self.playlist = playlist
        
        super.init(songs: songs)
        
        configureButtons()
        configureTableView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [playlistSettingButton, addButton]

        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = title
        configureButtons()
        
        view.backgroundColor = .systemBackground
    }
    
    private func configureButtons(){
        playlistSettingButton.image = UIImage(systemName: "ellipsis")
        playlistSettingButton.tintColor = .systemRed
        
        addTargetToButton(boton: addButton, target: self, action: #selector(addSongToPlaylist))
    }
    
    @objc private func addSongToPlaylist(){
        let songVC = SongSelectorVC(playlistTitle: playlist.name)
        
        songVC.onSongSelected = { [weak self] newSong in
            guard let self = self else { return }
            self.tableView.addSong(song: newSong)
        }
        
        let nv = UINavigationController(rootViewController: songVC)
        present(nv, animated: true)
    }
    
    override func deleteSong(at index: Int) {
        let song = tableView.songs[index] as Song
        
        FileManagerHelper.deleteSongOfPlaylistFromCoreData(playlistTitle: playlist.name, songTitle: song.title!)
        tableView.songs.remove(at: index)
        tableView.tableView.reloadData()
    }

}


