//
//  SongPlayerManager.swift
//  DGPlayer
//
//  Created by David Gutierrez on 25/3/25.
//

import UIKit
import AVFoundation


/// Clase que maneja el reproductor de música.
class SongPlayerManager {
    
    /// Única instancia del manejador.
    static let shared = SongPlayerManager()
    
    /// Reproductor de música a utilizar.
    private(set) var player: AVAudioPlayer?
    
    /// Canción que se está reproduciendo en el momento.
    private(set) var song: Song?
    
    /// Canciones que el reproductor puede cargar y reproducir.
    private(set) var songs: [Song] = []
    
    /// Indice de la canción que se está reproduciendo en el mismo momento.
    private(set) var selectedIndex: Int = 0
    
    /// Indica si los controles remotos (desde fuera de la aplicación) están configurados.
    var remoteCommandsConfigured = false
    
    /// Indica si el reproductor de música está configurado.
    var isSongPlayerConfigured = false
    
    /// Indica si la siguiente canción a reproducir debe ser aleatoria.
    var reproduceRandomSongAsNext = false
    
    /// Indica si se debe reproducir toda la playlist completa.
    var reproduceAllPlaylist = false
    
    /// Indica si una canción se debe reproducir continuámente, sin pasar a ninguna
    /// otra canción.
    var isLoopingSong = false
    
    /// Indica si la reproducción de canciones es la habitual. Se reproduce una canción y cuando
    /// esta acaba se detiene la reproducción.
    var simpleReproduction = true
    
    /// Constructor privado de la clase. Inicializa el reproductor de música.
    private init(){
        player = AVAudioPlayer()
    }
    
    
    /// Configura el reproductor de música con el archivo a reproducir e inicia una sesión de audio en
    /// segundo plano.
    /// - Parameters:
    ///   - url: ruta del archivo de audio a reproducir.
    ///   - delegate: manejador de la sesión de audio.
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
    
    /// Establece la canción a reproducir.
    /// - Parameter song: canción a reproducir.
    func setSong(song: Song){
        self.song = song
    }
    
    /// Establece las canciones a cargar y el indice de la canción actual
    /// a reproducir.
    /// - Parameters:
    ///   - songs: canciones a cargar por el reproductor.
    ///   - selectedIndex: indice de la canción actual a reproducir.
    func setSongs(songs: [Song], selectedIndex: Int){
        self.songs = songs
        self.selectedIndex = selectedIndex
        self.song = songs[selectedIndex]
    }
    
    /// Configura la sesión de audio en segundo plano para que la música
    /// se pueda reproducir desde fuera de la aplicación.
    func configureAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("No se ha podido establacer una sesión")
        }
    }
    
    
    /// Establece si la siguiente canción a reproducir debe ser aleatoria.
    /// - Parameter activated: activa la opción de reproducción aleatoria.
    func configureReproduceRandomSongAsNext(activated: Bool){
        reproduceRandomSongAsNext = activated
        
        simpleReproduction = (!activated)
        reproduceAllPlaylist = (!activated)
        isLoopingSong = (!activated)
        
    }
    
    /// Establece si se debe reproducir toda las canciones de la playlist.
    /// - Parameter activated: activa la opción de reproducción completa de la playlist.
    func configureReproduceAllPlaylist(activated: Bool){
        reproduceAllPlaylist = activated
        
        simpleReproduction = (!activated)
        reproduceRandomSongAsNext = (!activated)
        isLoopingSong = (!activated)
    }
    
    
    /// Establece si se debe reproducir en bucle la canción actual.
    /// - Parameter activated: activa la opción de reproducción en bucle.
    func configureLoopingSong(activated: Bool){
        isLoopingSong = activated
        
        reproduceRandomSongAsNext = (!activated)
        simpleReproduction = (!activated)
        reproduceAllPlaylist = (!activated)
    }
    
    /// Establece si la reproducción de música debe ser la configurada por defecto.
    /// - Parameter activated: activa la opción de reproducción normal.
    func configureSimpleReproduction(activated: Bool){
        simpleReproduction = activated
        
        reproduceRandomSongAsNext = (!activated)
        reproduceAllPlaylist = (!activated)
        isLoopingSong = (!activated)
    }

}
