//
//  Song.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

struct Song {
    let title: String?
    let artist: String?
    let band: String?
    let image: UIImage?
    
    init(){
        title = "Title"
        artist = "Artists"
        band = "Band"
        image = UIImage()
    }
    
    init(title: String?, artist: String?, band: String?, image: UIImage?) {
        self.title = title
        self.artist = artist ?? "Unknown"
        self.band = band ?? "Unknown"
        self.image = image
    }
}
