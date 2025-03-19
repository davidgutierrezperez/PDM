//
//  SongPlayerVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit
import AVFoundation

class SongPlayerVC: UIViewController, DGSongControlDelegate {
    
    private var song: Song
    private var songs: [Song]
    private var indexSelectedSong: Int
    
    private var albumArtImageView: UIImageView!
    private var songTitle: UILabel!
    
    private var songControls = DGSongControl()
    private var isSongLooping = false
    
    private var optionButton = UIBarButtonItem()
    private var songOptions = SongOptionsVC()
    
    private var audioPlayer: AVAudioPlayer?
    private var timerSong: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationItem.backButtonTitle = "Home"
        navigationItem.largeTitleDisplayMode = .never
        
        updateFavoriteIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteIcon()
        updateOptions()
    }
    
    
    init(indexSelectedSong: Int, songs: [Song]) {
        self.indexSelectedSong = indexSelectedSong
        self.songs = songs
        self.song = self.songs[self.indexSelectedSong]
        songControls.songCurrentTimer = 0.0
        
        
        super.init(nibName: nil, bundle: nil)
        
        
        configureSongTitle(title: song.title!)
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
                songControls.changePauseButtonSymbol(systemName: DGSongControl.playIcon)
            } else {
                player.play()
                startProgressTime()
                songControls.changePauseButtonSymbol(systemName: DGSongControl.pauseIcon)
            }
        } else {
            playSong()
            startProgressTime()
            songControls.changePauseButtonSymbol(systemName: DGSongControl.playIcon)
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
    
    
    @objc private func repeatSong(){
        guard let player = audioPlayer else { return }
        
        if (!isSongLooping){
            isSongLooping = true
            player.numberOfLoops = Int.max
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.isRepeatingIcon)
        } else {
            isSongLooping = false
            player.numberOfLoops = 0
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
        }
        
    }
    
    @objc private func randomSong(){
        guard let player = audioPlayer else { return }
        
        let randomNumber = Int.random(in: 0...(songs.count - 1))
        updateView(with: songs[randomNumber])
    }
    
    @objc private func addSongToFavourites(){
        FileManagerHelper.addSongToFavourites(title: song.title!)
            
        let favouriteIcon = FileManagerHelper.isSongInFavourites(title: songs[indexSelectedSong].title!) ? DGSongControl.favouriteIcon : DGSongControl.noFavouriteIcon
        changeAddToFavouriteButtonSymbol(systemName: favouriteIcon)
    }
    
    @objc private func showSongOptions(){
        navigationController?.pushViewController(songOptions, animated: true)
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

    
    private func changeAddToFavouriteButtonSymbol(systemName: String){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        songControls.addToFavouriteButton.setImage(UIImage(systemName: systemName, withConfiguration: largeConfig), for: .normal)
    }
    
    
    
    private func updateFavoriteIcon(){
        if (FileManagerHelper.isSongInFavourites(title: songs[indexSelectedSong].title!)){
            changeAddToFavouriteButtonSymbol(systemName: DGSongControl.favouriteIcon)
        } else {
            changeAddToFavouriteButtonSymbol(systemName: DGSongControl.noFavouriteIcon)
        }
    }

    
    private func configureProgressSlider(){
        songControls.progressSlider.isUserInteractionEnabled = true
        songControls.progressSlider.isContinuous = true
        
        songControls.progressSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }

    
    private func configureButtons(){
        songControls.pauseButton.addTarget(self, action: #selector(playPauseSong), for: .touchUpInside)
        songControls.backwardButton.addTarget(self, action: #selector(changeToPreviousSong), for: .touchUpInside)
        songControls.forwardButton.addTarget(self, action: #selector(changeToNextSong), for: .touchUpInside)
        songControls.repeatButton.addTarget(self, action: #selector(repeatSong), for: .touchUpInside)
        songControls.randomSongButton.addTarget(self, action: #selector(randomSong), for: .touchUpInside)
        songControls.addToFavouriteButton.addTarget(self, action: #selector(addSongToFavourites), for: .touchUpInside)
        
        if (song.isFavourite){
            changeAddToFavouriteButtonSymbol(systemName: DGSongControl.favouriteIcon)
        }
        
        configureOptionButton()
    }
    
    private func configureOptionButton(){
        optionButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showSongOptions))
        optionButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = optionButton
    }
    
    private func configureImageSong(){
        self.albumArtImageView = UIImageView(image: song.image ?? UIImage(systemName: "music.note"))
        self.albumArtImageView.contentMode = .scaleToFill
        albumArtImageView.clipsToBounds = true
        
        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSongTitle(title: String){
        let newSongTitle = UILabel()
        let maxCharacters = 40
        if title.count > maxCharacters {
            let index = song.title!.index(title.startIndex, offsetBy: maxCharacters)
            newSongTitle.text = String(title[..<index]) + "..."
        } else {
            newSongTitle.text = title
        }
        newSongTitle.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        newSongTitle.translatesAutoresizingMaskIntoConstraints = false
        
        songTitle = newSongTitle
    }
    
    private func disableButtonsWhenSearching(){
        songControls.backwardButton.isEnabled = false
        songControls.forwardButton.isEnabled = false
        songControls.randomSongButton.isEnabled = false
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

        // 🔹 Iniciar el timer solo si el audio tiene duración válida
        if player.duration > 0 {
            startProgressTime()
        }
    }
    
    private func configure(){
        view.addSubview(albumArtImageView)
        view.addSubview(songTitle)
        view.addSubview(songControls.addToFavouriteButton)
        
        albumArtImageView.layer.cornerRadius = 10

        addChild(songControls)
        view.addSubview(songControls.view)
        songControls.didMove(toParent: self)

        if songs.count == 1 {
            disableButtonsWhenSearching()
        }

        songControls.view.translatesAutoresizingMaskIntoConstraints = false
        songTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 🔹 Imagen del álbum (arriba, centrada)
            albumArtImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            albumArtImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArtImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            albumArtImageView.heightAnchor.constraint(equalTo: albumArtImageView.widthAnchor),

            // 🔹 Título de la canción (debajo de la imagen, alineado a la izquierda)
            songTitle.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 15),
            songTitle.leadingAnchor.constraint(equalTo: albumArtImageView.leadingAnchor),

            // 🔹 Botón de favorito (debajo de la imagen, alineado a la derecha)
            songControls.addToFavouriteButton.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor, constant: 15),
            songControls.addToFavouriteButton.trailingAnchor.constraint(equalTo: albumArtImageView.trailingAnchor),

            // 🔹 Controles (debajo del título y botón)
            songControls.view.topAnchor.constraint(equalTo: songTitle.bottomAnchor, constant: 40),
            songControls.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songControls.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songControls.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])


    }
    
    private func updateSongTitle(with title: String?) {
        guard let title = title, !title.isEmpty else {
            songTitle?.text = "Unknown Title" 
            return
        }

        let maxCharacters = 40
        if title.count > maxCharacters {
            let index = title.index(title.startIndex, offsetBy: maxCharacters)
            songTitle?.text = String(title[..<index]) + "..."
        } else {
            songTitle?.text = title
        }
    }
    
    func updateOptions(){
        print("Ejecutando updateOptions")
        if (songOptions.options[1].isOptionEnabled){
            isSongLooping = true
            audioPlayer?.numberOfLoops = Int.max
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.isRepeatingIcon)
        } else {
            isSongLooping = false
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
        }
    }
    
    private func updateView(with song: Song){
        self.song = song
        
        audioPlayer?.stop()
        resetTimers()
        
        albumArtImageView.image = song.image ?? UIImage(systemName: "music.note")
        songControls.changePauseButtonSymbol(systemName: DGSongControl.playIcon)
        updateSongTitle(with: song.title)
        
        let songIsFavourite = FileManagerHelper.isSongInFavourites(title: song.title!)
        let favouriteIcon = songIsFavourite ? DGSongControl.favouriteIcon : DGSongControl.noFavouriteIcon
        changeAddToFavouriteButtonSymbol(systemName: favouriteIcon)
        updateOptions()

        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension SongPlayerVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        songControls.changePauseButtonSymbol(systemName: DGSongControl.playIcon)
    }
}
