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
    private var songs: [Song]
    private var indexSelectedSong: Int
    
    private var pauseButton: UIButton!
    private var backwardButton: UIButton!
    private var forwardButton: UIButton!
    
    private var albumArtImageView: UIImageView!
    private var songTitle: String!
    private var songDuration: TimeInterval = 0.0
    private var songCurrentTime: TimeInterval = 0.0
    private var songCurrentTimeLabel: UILabel!
    private var songDurationLabel: UILabel!
    
    private var audioPlayer: AVAudioPlayer?
    private var timerSong: Timer!
    private var progressSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.backButtonTitle = "Home"
    }
    
    init(indexSelectedSong: Int, songs: [Song]) {
        self.indexSelectedSong = indexSelectedSong
        self.songs = songs
        self.song = self.songs[self.indexSelectedSong]
        self.songTitle = self.song.title
        
        self.songCurrentTime = 0.0
    
        super.init(nibName: nil, bundle: nil)
        
        title = song.title
        songCurrentTimeLabel = UILabel()
        songDurationLabel = UILabel()
        
        
        
        
        resetTimers()
        configureButtons()
        configureImageSong()
        configureProgressSlider()
        
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func activateAudioPlayer(){
        guard let audioPath = song.audio?.lastPathComponent else { return }
        let audioURL = FileManagerHelper.getFilePath(from: audioPath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL!)
            songDuration = audioPlayer?.duration ?? 0.0
            audioPlayer?.delegate = self
        } catch {
            print("No se pudo activar el reproductor de audio")
        }
    }
    
    @objc private func playSong(){
        audioPlayer?.play()
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
                
                let newIcon = (player.currentTime == player.duration) ? "play.fill" : "pause.fill"
                changePauseButtonSymbol(systemName: newIcon)
            }
        } else {
            playSong()
            startProgressTime()
            changePauseButtonSymbol(systemName: "pause.fill")
        }
    }
    
    @objc private func changeToNextSong(){
        indexSelectedSong = (indexSelectedSong == songs.count - 1) ? 0 : (indexSelectedSong + 1)
        updateView(with: songs[indexSelectedSong])
    }
    
    @objc private func changeToPreviousSong(){
        indexSelectedSong = (indexSelectedSong == 0) ? (songs.count - 1) : (indexSelectedSong - 1)
        updateView(with: songs[indexSelectedSong])
    }
    
    @objc private func sliderChanged(_ sender: UISlider){
        guard let player = audioPlayer else { return }
        player.currentTime = TimeInterval(sender.value) * player.duration
    }
    
    
    private func startProgressTime(){
        timerSong?.invalidate()
        timerSong = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.progressSlider.value = Float(player.currentTime / player.duration)
            self.songCurrentTime = player.currentTime
            self.songCurrentTimeLabel.text = formatTime(time: player.currentTime)
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
    
    private func disableBackAndForwardButtons(){
        backwardButton.isEnabled = false
        forwardButton.isEnabled = false
    }
    
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func resetTimers(){
        activateAudioPlayer()
        
        songCurrentTimeLabel.text = "0:00"
        songDurationLabel.text = formatTime(time: audioPlayer!.duration)
    }
    
    private func configure(){
        // Agregar subviews
        view.addSubview(progressSlider)
        view.addSubview(albumArtImageView)
        view.addSubview(backwardButton)
        view.addSubview(pauseButton)
        view.addSubview(forwardButton)
        view.addSubview(songDurationLabel)
        view.addSubview(songCurrentTimeLabel)
        
        if (songs.count == 1){
            disableBackAndForwardButtons()
        }

        // Usamos Auto Layout para posicionar los elementos
        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        songDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        songCurrentTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 🔹 Imagen de portada (arriba del todo)
            albumArtImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            albumArtImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArtImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            albumArtImageView.heightAnchor.constraint(equalTo: albumArtImageView.widthAnchor),

            // 🔹 Tiempo actual (izquierda, debajo de la imagen, encima del slider)
            songCurrentTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            songCurrentTimeLabel.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 20),

            // 🔹 Tiempo total (derecha, debajo de la imagen, encima del slider)
            songDurationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            songDurationLabel.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 20),

            // 🔹 Barra de progreso (debajo de los labels)
            progressSlider.topAnchor.constraint(equalTo: songCurrentTimeLabel.bottomAnchor, constant: 20),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            progressSlider.heightAnchor.constraint(equalToConstant: 2),

            // 🔹 Botones de control (debajo del slider)
            backwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            backwardButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 20),

            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            forwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            forwardButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor)
        ])


    }
    
    private func updateView(with song: Song){
        self.song = song
        
        title = song.title
        audioPlayer?.stop()
        albumArtImageView.image = song.image ?? UIImage(systemName: "music.note")
        resetTimers()
        changePauseButtonSymbol(systemName: "play.fill")
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
        
        
}

extension SongVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        changePauseButtonSymbol(systemName: "play.fill")
    }
}



