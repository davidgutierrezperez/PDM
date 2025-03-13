//
//  SongVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit
import AVFoundation

class SongVC: UIViewController {
    
    private var song: Song
    private var pauseButton: UIButton!
    private var backwardButton: UIButton!
    private var forwardButton: UIButton!
    private var albumArtImageView: UIImageView!
    private var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.backButtonTitle = "Home"
    }
    
    init(song: Song) {
        self.song = song
    
        super.init(nibName: nil, bundle: nil)
        
        // Inicializar los botones antes de super.init()
        self.pauseButton = configureButtonWithSystemNameImage(systemName: "pause.fill", target: self, action: #selector(playSong))
        self.backwardButton = configureButtonWithSystemNameImage(systemName: "backward.fill", target: self,  action: #selector(playSong))
        self.forwardButton = configureButtonWithSystemNameImage(systemName: "forward.fill", target: self, action: #selector(playSong))

        // Crear la imagen del álbum
        self.albumArtImageView = UIImageView(image: song.image ?? UIImage(systemName: "music.note"))
        self.albumArtImageView.contentMode = .scaleAspectFit

        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonWithSystemNameImage(systemName: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
    @objc private func playSong(){
        guard let audioPath = song.audio?.lastPathComponent else { return }
        let audioURL = FileManagerHelper.getDocumentsDirectory().appendingPathComponent(audioPath)
        
        print("El path del archivo es: ", audioURL)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        } catch {
            print("Error al reproducir la canción: \(error.localizedDescription)")
        }
    }
    
    private func configure(){
        // Agregar subviews
        view.addSubview(albumArtImageView)
        view.addSubview(backwardButton)
        view.addSubview(pauseButton)
        view.addSubview(forwardButton)

        // Usamos Auto Layout para posicionar los elementos
        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Imagen de portada
            albumArtImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            albumArtImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArtImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            albumArtImageView.heightAnchor.constraint(equalTo: albumArtImageView.widthAnchor),

            // Botones de control
            backwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            backwardButton.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 40),

            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            forwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            forwardButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor)
        ])
    }
        
        
}


