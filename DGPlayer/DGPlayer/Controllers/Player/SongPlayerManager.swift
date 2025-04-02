//
//  SongPlayerManager.swift
//  DGPlayer
//
//  Created by David Gutierrez on 25/3/25.
//

import UIKit
import AVFoundation

class SongPlayerManager {
    static let shared = SongPlayerManager()
    private(set) var player: AVAudioPlayer?
    
    private(set) var song: Song?
    private(set) var songs: [Song] = []
    private(set) var selectedIndex: Int = 0
    
    var remoteCommandsConfigured = false
    var isSongPlayerConfigured = false
    var reproduceRandomSongAsNext = false
    var reproduceAllPlaylist = false
    var isLoopingSong = false
    var simpleReproduction = true
    
    private init(){
        player = AVAudioPlayer()
    }
    
    func loadPlayer(with url: URL, delegate: AVAudioPlayerDelegate?) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.delegate = delegate
            self.player?.volume = 0.3
            
            self.isSongPlayerConfigured = true
        } catch {
            print("❌ Error al cargar el reproductor de audio: \(error)")
        }
    }
    
    func setSong(song: Song){
        self.song = song
    }
    
    func setSongs(songs: [Song], selectedIndex: Int){
        self.songs = songs
        self.selectedIndex = selectedIndex
        self.song = songs[selectedIndex]
    }
    
    func configureAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("No se ha podido establacer una sesión")
        }
    }
    
    func configureReproduceRandomSongAsNext(activated: Bool){
        reproduceRandomSongAsNext = activated
        
        simpleReproduction = (!activated)
        reproduceAllPlaylist = (!activated)
        isLoopingSong = (!activated)
        
    }
    
    func configureReproduceAllPlaylist(activated: Bool){
        reproduceAllPlaylist = activated
        
        simpleReproduction = (!activated)
        reproduceRandomSongAsNext = (!activated)
        isLoopingSong = (!activated)
    }
    
    func configureLoopingSong(activated: Bool){
        isLoopingSong = activated
        
        reproduceRandomSongAsNext = (!activated)
        simpleReproduction = (!activated)
        reproduceAllPlaylist = (!activated)
    }
    
    func configureSimpleReproduction(activated: Bool){
        simpleReproduction = activated
        
        reproduceRandomSongAsNext = (!activated)
        reproduceAllPlaylist = (!activated)
        isLoopingSong = (!activated)
    }

}
