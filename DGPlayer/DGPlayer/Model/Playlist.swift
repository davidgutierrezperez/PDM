//
//  Playlist.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

/// Modelo que representa una *playlist*.
struct Playlist {
    
    /// Nombre de la *playlist*.
    var name: String
    
    /// Imagen asociada a la *playlist*.
    var image: UIImage?
    
    /// Canciones asociadas a la *playlist*
    var songs: [Song]
    
    /// Constructor por defecto de una *playlist*.
    /// - Parameters:
    ///   - name: nombred de la *playlist*.
    ///   - image: imagen asociada a la *playlist*.
    ///   - songs: canciones incluidas en la *playlist*.
    init(name: String, image: UIImage?, songs: [Song] = []){
        self.name = name
        self.image = image
        self.songs = songs
    }
}
