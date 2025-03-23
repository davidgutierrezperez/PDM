//
//  PlaylistVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class PlaylistVC: SongsVC {
    
    private var playlists: [Playlist] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
        addTargetToButton(boton: addButton, target: self, action: #selector(addPlaylist))

        view.backgroundColor = .systemBackground
    }
    
    @objc private func addPlaylist(){
        let addPlaylistVC = PlaylistCreationVC(placeholder: "Playlist title")
        let navVC = UINavigationController(rootViewController: addPlaylistVC)
        
        self.present(navVC, animated: true)
    }
    

   

}
