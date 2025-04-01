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
    private var infoPlaylist: DGInfoCollection
    
    init(playlist: Playlist, songs: [Song]){
        
        self.playlist = playlist
        infoPlaylist = DGInfoCollection(image: playlist.image, title: playlist.name)
        
        super.init(songs: songs)
        
        self.navigationItem.title = title
        
        
        configureButtons()
        configureTableView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItems = [playlistSettingButton, addButton, enableSearchButton]

        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = title
        configureButtons()
        
        view.backgroundColor = .systemBackground
        
        setupHeader()
    }
    
    private func configureButtons(){
        playlistSettingButton.image = UIImage(systemName: "ellipsis")
        playlistSettingButton.tintColor = .systemRed
        
        addTargetToBarButton(boton: addButton, target: self, action: #selector(addSongToPlaylist))
        infoPlaylist.playFirstSongCollection.addTarget(self, action: #selector(playFirstSong), for: .touchUpInside)
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
    
    @objc private func playFirstSong(){
        SongPlayerVC.present(from: self, with: playlist.songs[0], songs: playlist.songs, selectedSong: 0)
    }
    
    override func deleteSong(at index: Int) {
        let song = tableView.songs[index] as Song
        
        FileManagerHelper.deleteSongOfPlaylistFromCoreData(playlistTitle: playlist.name, songTitle: song.title!)
        tableView.songs.remove(at: index)
        tableView.tableView.reloadData()
    }
    
    private func setupHeader() {
        let infoHeader = infoPlaylist
        tableView.setHeaderView(infoHeader)
    }


}

