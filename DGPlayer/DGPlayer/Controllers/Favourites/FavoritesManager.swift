//
//  FavoritesManager.swift
//  DGPlayer
//
//  Created by David Gutierrez on 25/3/25.
//

import UIKit


/// Clase que maneja las canciones catalogadas como favoritas.
class FavoritesManager {
    
    
    /// Única instancia de la clase a utilizar.
    static let shared = FavoritesManager()
    
    /// Canciones catalogadas como favoritos
    private(set) var songs: [Song] = []
    
    
    /// Constructor privado de **FavoritesManager**. Evita que la clase se pueda
    /// instanciar y usar como objecto e inicializa **songs** con las canciones
    /// almacenadas como favoritas.
    private init(){
        songs = FileManagerHelper.loadFavouriteSongsFromCoreData()
    }
    
    
    /// Añade o elimina una canción de favoritos en función de su estado actual.
    /// Si la canción no se encuentra catalogada como favorita, entonces se añadirá, en caso
    /// contrario, se eliminará de favoritos.
    /// - Parameter song: Canción cuyo estado de *favorito* se actualizará.
    func toggleFavourite(song: Song){
        if (songs.contains(song)){
            songs.removeAll(where: {$0.title == song.title})
        } else {
            songs.append(song)
        }
        
        FileManagerHelper.addSongToFavourites(title: song.title!)
    }
    
    
    /// Comprueba si una canción está calogada como favorita o no.
    /// - Parameter song: canción cuyo estado de *favorito* será comproboda.
    /// - Returns: devuelve **true** si la canción es favorita y **false** en caso contrario.
    func isFavourite(song: Song) -> Bool {
        return songs.contains(song)
    }
    
    /// Añade una canción al array de canciones favoritas.
    /// - Parameter song: canción a añadir.
    func addSong(song: Song){
        songs.append(song)
    }
    
    
    /// Elimina una canción del array de canciones favoritas.
    /// - Parameter song: canción a eliminar del array.
    func deleteSong(song: Song){
        songs.removeAll(where: {$0.title == song.title!})
    }
}
