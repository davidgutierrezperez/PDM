//
//  FavoritesManager.swift
//  DGPlayer
//
//  Created by David Gutierrez on 25/3/25.
//

import UIKit

class FavoritesManager {
    
    static let shared = FavoritesManager()
    private(set) var songs: [Song] = []
    
    private init(){
        songs = FileManagerHelper.loadFavouriteSongsFromCoreData()
    }
    
    func toggleFavourite(song: Song){
        if (songs.contains(song)){
            songs.removeAll(where: {$0.title == song.title})
        } else {
            songs.append(song)
        }
        
        FileManagerHelper.addSongToFavourites(title: song.title!)
    }
    
    func isFavourite(song: Song) -> Bool {
        return songs.contains(song)
    }
    
    func addSong(song: Song){
        songs.append(song)
    }
    
    func deleteSong(song: Song){
        songs.removeAll(where: {$0.title == song.title!})
    }
}
