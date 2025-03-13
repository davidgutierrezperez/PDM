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
    private var timerSong: Timer!
    private var progressSlider: UISlider!
    var nextSong: SongVC?
    var previousSong: SongVC?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.backButtonTitle = "Home"
    }
    
    init(song: Song) {
        self.song = song
    
        super.init(nibName: nil, bundle: nil)
        
        configureButtons()
        configureImageSong()
        configureProgressSlider()
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func playSong(){
        guard let audioPath = song.audio?.lastPathComponent else { return }
        let audioURL = FileManagerHelper.getFilePath(from: audioPath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        } catch {
            print("Error al reproducir la canción: \(error.localizedDescription)")
        }
    }
    
    @objc private func playPauseSong(){
        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                timerSong?.invalidate()
                changePauseButtonSymbol(systemName: "play.fill")
            } else {
                player.play()
                startProgressTime()
                changePauseButtonSymbol(systemName: "pause.fill")
            }
        } else {
            playSong()
            startProgressTime()
            changePauseButtonSymbol(systemName: "pause.fill")
        }
    }
    
    @objc private func sliderChanged(_ sender: UISlider){
        guard let player = audioPlayer else { return }
        player.currentTime = TimeInterval(sender.value) * player.duration
    }
    
    @objc private func changeToNextSong(){
        navigationController?.pushViewController(nextSong!, animated: true)
    }
    
    @objc private func changeToPreviousSong(){
        navigationController?.pushViewController(previousSong!, animated: true)
    }
    
    private func startProgressTime(){
        timerSong?.invalidate()
        timerSong = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.progressSlider.value = Float(player.currentTime / player.duration)
        }
    }
    
    private func configureButtonWithSystemNameImage(systemName: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }

    private func changePauseButtonSymbol(systemName: String){
        pauseButton.setImage(UIImage(systemName: systemName), for: .normal)
    }
    
    private func configureProgressSlider(){
        progressSlider = UISlider()
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.tintColor = .systemBlue
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        self.progressSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    
    private func configureButtons(){
        self.pauseButton = configureButtonWithSystemNameImage(systemName: "play.fill", target: self, action: #selector(playPauseSong))
        self.backwardButton = configureButtonWithSystemNameImage(systemName: "backward.fill", target: self,  action: #selector(changeToPreviousSong))
        self.forwardButton = configureButtonWithSystemNameImage(systemName: "forward.fill", target: self, action: #selector(changeToNextSong))
    }
    
    private func configureImageSong(){
        self.albumArtImageView = UIImageView(image: song.image ?? UIImage(systemName: "music.note"))
        self.albumArtImageView.contentMode = .scaleAspectFit
    }
    
    private func configure(){
        // Agregar subviews
        view.addSubview(progressSlider)
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

            // Barra de progreso encima de los botones
            progressSlider.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 20),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            progressSlider.heightAnchor.constraint(equalToConstant: 2), // Pequeña altura para la barra

            // Botones de control debajo de la barra de progreso
            backwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            backwardButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 20),

            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            forwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            forwardButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor)
        ])
    }
        
        
}



