//
//  AidFunctions.swift
//  DGPlayer
//
//  Created by David Gutierrez on 26/3/25.
//

import UIKit
import AVFoundation

/// Permite obtener la duración total de una canción como un *String*.
/// - Parameter audio: ruta del archivo de audio.
/// - Returns: cadena de texto con la duración de una canción.
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

/// Permite obtener una cadena de texto equivalente a un tiempo representado
/// mediante un objeto de tipo *TimeInterval*.
/// - Parameter time: tiempo a pasar a texto.
/// - Returns:cadena de texto equivalente al tiempo pasado como argumento.
func formatTime(time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
}
