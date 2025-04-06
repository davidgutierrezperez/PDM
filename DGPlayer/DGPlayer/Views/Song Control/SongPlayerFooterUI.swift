//
//  SongPlayerFooterUI.swift
//  DGPlayer
//
//  Created by David Gutierrez on 1/4/25.
//

import UIKit

/// Vista asociada al controlador SongPlayerFooterVC.
class SongPlayerFooterUI: UIView {
    
    /// Imagen asociada a la canción que se está reproduciendo.
    private var imageSong = UIImageView()
    
    /// Título de la canción que se está reproduciendo.
    private var titleSong = UILabel()
    
    /// Botón que permite la reproducción y pausa de la canción.
    var playIcon = TouchableButton()

    /// Constructor por defecto. Configura la vista.
    init(){
        super.init(frame: .zero)
        
        setupView()
    }

    /// Inicializador requerido para cargar la vista desde un archivo storyboard o nib.
    ///
    /// Este inicializador es necesario cuando se utiliza Interface Builder para crear
    /// instancias del controlador. En este caso particular, como el controlador se
    /// configura completamente de forma programática, el uso de storyboards no está soportado,
    /// por lo que se lanza un `fatalError` si se intenta usar.
    ///
    /// - Parameter coder: Objeto utilizado para decodificar la vista desde un archivo nib o storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Permite cambiar el icono del botón de reproducción a audio.
    /// - Parameter systemName: nombre del icono/símbolo a asignar al botón.
    func changePlaySongIcon(systemName: String){
        playIcon.setImage(UIImage(systemName: systemName), for: .normal)
    }
    
    /// Actualiza la vista con la información de una nueva canción.
    /// - Parameter song: canción con la que se actualizará la vista.
    func updateView(with song: Song){
        imageSong.image = song.image ?? UIImage(systemName: "music.note")!
        titleSong.text = song.title ?? "Unknown song"
        
        let playPauseIcon = (SongPlayerManager.shared.player?.isPlaying == true) ? DGSongControl.pauseIcon : DGSongControl.playIcon
        
        playIcon.setImage(UIImage(systemName: playPauseIcon), for: .normal)
        playIcon.tintColor = .systemRed
    }
    
    /// Configura la vista y añade los diferentes elementos.
    private func setupView(){
        addSubview(imageSong)
        addSubview(titleSong)
        addSubview(playIcon)
        
        imageSong.translatesAutoresizingMaskIntoConstraints = false
        titleSong.translatesAutoresizingMaskIntoConstraints = false
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageSong.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageSong.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageSong.widthAnchor.constraint(equalToConstant: 40),
            imageSong.heightAnchor.constraint(equalToConstant: 40),

            playIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            playIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 25),
            playIcon.heightAnchor.constraint(equalToConstant: 25),

            titleSong.leadingAnchor.constraint(equalTo: imageSong.trailingAnchor, constant: 12),
            titleSong.trailingAnchor.constraint(equalTo: playIcon.leadingAnchor, constant: -12),
            titleSong.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
