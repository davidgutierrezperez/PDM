//
//  PlaylistSongsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

class PlaylistSongsVC: SongsVC {
    
    private let playlistSettingButton = UIBarButtonItem()
    
    init(playlist: Playlist, songs: [Song]){
        
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
        
        view.backgroundColor = .systemBackground
    }
    
    private func configureButtons(){
        playlistSettingButton.image = UIImage(systemName: "ellipsis")
        playlistSettingButton.tintColor = .systemRed
    }

}


