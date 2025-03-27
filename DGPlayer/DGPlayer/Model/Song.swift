//
//  Song.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import CoreData

struct Song: Equatable, Hashable {
    let title: String?
    let artist: String?
    let band: String?
    let image: UIImage?
    let audio: URL?
    var isFavourite: Bool
    let duration: String?
    
    init(){
        title = "Title"
        artist = "Artists"
        band = "Band"
        image = UIImage()
        audio = nil
        isFavourite = false
        duration = "00:00"
    }
    
    init(title: String?, artist: String?, band: String?, image: UIImage?, audio: URL?, isFavourite: Bool, duration: String?) {
        self.title = title
        self.artist = artist ?? "Unknown"
        self.band = band ?? "Unknown"
        self.image = image
        self.audio = audio
        self.isFavourite = isFavourite
        self.duration = duration
    }
}


