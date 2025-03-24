//
//  Playlist.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

struct Playlist {
    var name: String
    var image: UIImage?
    var songs: [Song]
    
    init(name: String, image: UIImage?, songs: [Song] = []){
        self.name = name
        self.image = image
        self.songs = songs
    }
}
