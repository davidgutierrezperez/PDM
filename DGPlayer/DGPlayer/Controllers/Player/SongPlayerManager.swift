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
    
    private init(){
        player = AVAudioPlayer()
    }
    
    func loadPlayer(with url: URL, delegate: AVAudioPlayerDelegate?) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.delegate = delegate
            self.player?.volume = 0.3
        } catch {
            print("❌ Error al cargar el reproductor de audio: \(error)")
        }
    }

}
