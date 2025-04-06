//
//  Song.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import CoreData

/// Modelo que representa una canción.
struct Song: Equatable, Hashable {
    let title: String?
    let artist: String?
    let band: String?
    let image: UIImage?
    let audio: URL?
    var isFavourite: Bool
    let duration: String?
    
    /// Constructor vacio de una canción. No dispone de audio ni información asociada.
    init(){
        title = "Title"
        artist = "Artists"
        band = "Band"
        image = UIImage()
        audio = nil
        isFavourite = false
        duration = "00:00"
    }
    
    /// Constructor por defecto de una canción.
    /// - Parameters:
    ///   - title: título de la canción.
    ///   - artist: artista asociado a la canción.
    ///   - band: banda asociada a la canción.
    ///   - image: imagen asociada a la canción.
    ///   - audio: audio de la canción.
    ///   - isFavourite: índice si la canción está catalogada como favorita.
    ///   - duration: duración de la canción.
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


