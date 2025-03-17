//
//  SongVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit
import AVFoundation

class SongVC: UIViewController, DGSongControlDelegate {
    
    private var song: Song
    private var songs: [Song]
    private var indexSelectedSong: Int
    
    private var albumArtImageView: UIImageView!
    
    private var songControls = DGSongControl()
    
    private var audioPlayer: AVAudioPlayer?
    private var timerSong: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.backButtonTitle = "Home"
    }
    
    init(indexSelectedSong: Int, songs: [Song]) {
        self.indexSelectedSong = indexSelectedSong
        self.songs = songs
        self.song = self.songs[self.indexSelectedSong]
        
        songControls.songCurrentTimer = 0.0
    
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        title = song.title
        
        resetTimers()
        configureButtons()
        configureVolumeButtons()
        configureImageSong()
        configureProgressSlider()
        configureVolumeSlider()
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
            songControls.songDurationTimer = audioPlayer?.duration ?? 0.0
            audioPlayer?.delegate = self
            audioPlayer?.volume = 0.3
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
                changePauseButtonSymbol(systemName: "pause.fill")
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
        
        let newTime = TimeInterval(sender.value) * player.duration
        player.currentTime = newTime
        
        songControls.songCurrentLabel.text = formatTime(time: newTime)
    }
    
    @objc private func volumeSliderChanged(_ send: UISlider){
        guard let player = audioPlayer else { return }
        
        player.volume = songControls.volumeSlider.value
        songControls.changeVolumeIcon()
    }
    
    @objc private func noVolumeSong(){
        guard let player = audioPlayer else { return }
        
        player.volume = 0
        songControls.volumeSlider.value = 0
    }
    
    func progressSliderChanged(to value: Float) {}
    func volumeSliderChanged(to value: Float){}
    
    
    private func startProgressTime(){
        timerSong?.invalidate()
        timerSong = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }

            // Si el usuario está moviendo el slider, no sobrescribir su valor
            if self.songControls.progressSlider.isTracking { return }

            self.songControls.progressSlider.value = Float(player.currentTime / player.duration)
            self.songControls.songCurrentLabel.text = self.formatTime(time: player.currentTime)
        }
    }

    private func changePauseButtonSymbol(systemName: String){
        songControls.pauseButton.setImage(UIImage(systemName: systemName), for: .normal)
    }
    
    @objc private func progressiveVolumeButton(){
        guard let player = audioPlayer else { return }
        
        let newVolume = (player.volume + 0.33 < 1) ? player.volume + 0.33 : 1
        player.volume = newVolume
        
        songControls.volumeSlider.value = newVolume
        songControls.changeVolumeIcon()
    }
    
    private func configureVolumeButtons(){
        songControls.noVolumeButton.addTarget(self, action: #selector(noVolumeSong), for: .touchUpInside)
        songControls.progressiveVolumeButton.addTarget(self, action: #selector(progressiveVolumeButton), for: .touchUpInside)
    }
    
    private func configureProgressSlider(){
        songControls.progressSlider.isUserInteractionEnabled = true
        songControls.progressSlider.isContinuous = true
        
        songControls.progressSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    private func configureVolumeSlider(){
        songControls.volumeSlider.isUserInteractionEnabled = true
        songControls.volumeSlider.isContinuous = true
        
        songControls.volumeSlider.addTarget(self, action: #selector(volumeSliderChanged(_:)), for: .valueChanged)
    }
    
    private func configureButtons(){
        songControls.pauseButton.addTarget(self, action: #selector(playPauseSong), for: .touchUpInside)
        songControls.backwardButton.addTarget(self, action: #selector(changeToPreviousSong), for: .touchUpInside)
        songControls.forwardButton.addTarget(self, action: #selector(changeToNextSong), for: .touchUpInside)
    }
    
    private func configureImageSong(){
        self.albumArtImageView = UIImageView(image: song.image ?? UIImage(systemName: "music.note"))
        self.albumArtImageView.contentMode = .scaleAspectFit
        
        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func disableBackAndForwardButtons(){
        songControls.backwardButton.isEnabled = false
        songControls.forwardButton.isEnabled = false
    }
    
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func resetTimers(){
        activateAudioPlayer()

        guard let player = audioPlayer else {
            print("Error: audioPlayer no está inicializado aún")
            return
        }

        songControls.songCurrentLabel.text = "0:00"
        songControls.songDurationLabel.text = formatTime(time: player.duration)
        songControls.volumeSlider.value = 0.5

        // 🔹 Iniciar el timer solo si el audio tiene duración válida
        if player.duration > 0 {
            startProgressTime()
        }
    }
    
    private func configure(){
        view.addSubview(albumArtImageView)

        addChild(songControls)
        view.addSubview(songControls.view)
        songControls.didMove(toParent: self)

        if songs.count == 1 {
            disableBackAndForwardButtons()
        }

        songControls.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            albumArtImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            albumArtImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArtImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            albumArtImageView.heightAnchor.constraint(equalTo: albumArtImageView.widthAnchor),

            songControls.view.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 30),
            songControls.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songControls.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songControls.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateView(with song: Song){
        self.song = song
        title = song.title
        
        audioPlayer?.stop()
        resetTimers()
        
        albumArtImageView.image = song.image ?? UIImage(systemName: "music.note")
        changePauseButtonSymbol(systemName: "play.fill")

        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension SongVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        changePauseButtonSymbol(systemName: "play.fill")
    }
}
