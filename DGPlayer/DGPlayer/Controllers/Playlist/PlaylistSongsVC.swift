//
//  PlaylistSongsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

class PlaylistSongsVC: SongsVC {
    
    private var infoPlaylist: DGInfoCollection
    
    init(playlist: Playlist, songs: [Song]){
        self.infoPlaylist = DGInfoCollection(image: playlist.image, title: playlist.name)
        
        super.init(songs: songs)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    private func configureInfoPlaylist(){
        addChild(infoPlaylist)
        view.addSubview(infoPlaylist.view)
        infoPlaylist.didMove(toParent: self)
        
        infoPlaylist.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func configureTableView(){
        tableView.tableView.delegate = self
        tableView.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView.tableView)
        tableView.tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupView(){
        configureInfoPlaylist()
        configureTableView()
        
        NSLayoutConstraint.activate([
                // 🔹 Info Playlist arriba
                infoPlaylist.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                infoPlaylist.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                infoPlaylist.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                infoPlaylist.view.heightAnchor.constraint(equalToConstant: 350),

                // 🔹 Tabla justo debajo
                tableView.tableView.topAnchor.constraint(equalTo: infoPlaylist.view.bottomAnchor, constant: 20),
                tableView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    
}


