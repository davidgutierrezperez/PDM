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
    var remoteCommandsConfigured = false
    var isSongPlayerConfigured = false
    
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
    
    func configureAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("No se ha podido establacer una sesión")
        }
    }

}
