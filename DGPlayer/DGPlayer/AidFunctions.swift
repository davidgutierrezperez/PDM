//
//  AidFunctions.swift
//  DGPlayer
//
//  Created by David Gutierrez on 26/3/25.
//

import UIKit
import AVFoundation

func getDurationFromSong(of audio: URL) -> String? {
    do {
        let player = try AVAudioPlayer(contentsOf: audio)
        let duration = formatTime(time: player.duration)
        
        return duration
    } catch {
        print("No se ha podido obtener la duración de la canción")
    }
    
    return nil
}

func formatTime(time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
}
