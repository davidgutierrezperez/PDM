//
//  SongPlayerVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit
import AVFoundation
import MediaPlayer

class SongPlayerVC: UIViewController, DGSongControlDelegate {
    
    // VARIABLES
    
    static var shared: SongPlayerVC?
    
    private var song: Song
    private var songs: [Song]
    private var indexSelectedSong: Int
    
    private var albumArtImageView: DGSongImagePlayer!
    private var songTitle: UILabel!
    
    private var songControls = DGSongControl()
    private var isSongLooping = false
    
    private var optionButton = UIBarButtonItem()
    private var songOptions = SongOptionsVC()
    
    private var enableProgressSlider = true
    
    private var timerSong: Timer!
    
    // CONSTRUCTORS
    
    init(indexSelectedSong: Int, songs: [Song]) {
        self.indexSelectedSong = indexSelectedSong
        self.songs = songs
        self.song = self.songs[self.indexSelectedSong]
        songControls.songCurrentTimer = 0.0
        songControls.songDurationLabel.text = song.duration
        
        super.init(nibName: nil, bundle: nil)
        
        configureSongTitle(title: song.title!)
        resetTimers()
        configureButtons()
        configureImageSong()
        configureProgressSlider()

        configure()
        
        SongPlayerManager.shared.setSong(song: song)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func present(from parent: UIViewController, with song: Song, songs: [Song], selectedSong: Int){
        if let existingVC = SongPlayerVC.shared {
            existingVC.updateView(with: songs[selectedSong], songs: songs, selectedIndex: selectedSong)
            parent.navigationController?.pushViewController(existingVC, animated: true)
        } else {
            let vc = SongPlayerVC(indexSelectedSong: selectedSong, songs: songs)
            SongPlayerVC.shared = vc
            parent.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        SongPlayerVC.shared = nil
    }
    
    
    // OVERLOADING FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .systemRed
        navigationItem.largeTitleDisplayMode = .never
        tabBarController?.tabBar.isHidden = true
        fondo()
        updateFavoriteIcon()
        
        if (!SongPlayerManager.shared.isSongPlayerConfigured){
            SongPlayerManager.shared.configureAudioSession()
            activateAudioPlayer()
        }
        setupRemoteCommandCenter()
        
    }
    
    private func fondo(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.lightGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // Degradado vertical
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
            
        let gradientView = UIView(frame: view.bounds)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        // 🔹 2. Aplica desenfoque (Blur Effect)
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds

        // 🔹 3. Añadir al ViewController
        view.addSubview(gradientView)
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteIcon()
        updateOptions()
        
        print(songs.count)
        
        if (songs.count == 1){
            disableButtonsWhenSearching()
        }
        
        tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        songControls.changePauseButtonSymbol(systemName: DGSongControl.pauseIcon)
    }
    
    private func activateAudioPlayer(){
        guard let audioPath = song.audio?.lastPathComponent else { return }
        let audioURL = FileManagerHelper.getFilePath(from: audioPath)
        
        do {
            
            SongPlayerManager.shared.loadPlayer(with: audioURL!, delegate: self)
            SongPlayerManager.shared.player?.delegate = self
            SongPlayerManager.shared.player?.volume = 0.3
            
            SongPlayerManager.shared.player?.prepareToPlay()
            SongPlayerManager.shared.isSongPlayerConfigured = true
            SongPlayerManager.shared.setSong(song: song)
            SongPlayerManager.shared.setSongs(songs: songs, selectedIndex: indexSelectedSong)
            
            mediaPlayerInfo()
        } catch {
            print("No se pudo activar el reproductor de audio")
        }
    }
    
    @objc private func playSong(){
        SongPlayerManager.shared.player?.play()
        mediaPlayerInfo()
    }
    
    @objc private func playPauseSong(){
        guard var player = SongPlayerManager.shared.player else { return }

        if player.isPlaying {
            player.pause()
            timerSong?.invalidate()
            songControls.changePauseButtonSymbol(systemName: DGSongControl.playIcon)
        } else {
            player.play()
            startProgressTime()
            songControls.changePauseButtonSymbol(systemName: DGSongControl.pauseIcon)
        }
        
        mediaPlayerInfo()
    }
    
    @objc private func changeToNextSong(){
        indexSelectedSong = (indexSelectedSong == songs.count - 1) ? 0 : (indexSelectedSong + 1)
        updateView(with: songs[indexSelectedSong], songs: songs, selectedIndex: indexSelectedSong)
    }
    
    @objc private func changeToPreviousSong(){
        indexSelectedSong = (indexSelectedSong == 0) ? (songs.count - 1) : (indexSelectedSong - 1)
        updateView(with: songs[indexSelectedSong], songs: songs, selectedIndex: indexSelectedSong)
    }
    
    @objc private func sliderChanged(_ sender: UISlider){
        guard let player = SongPlayerManager.shared.player else { return }
        
        let newTime = TimeInterval(sender.value) * player.duration
        player.currentTime = newTime
        
        songControls.songCurrentLabel.text = formatTime(time: newTime)
    }
    
    
    @objc private func repeatSong(){
        guard let player = SongPlayerManager.shared.player else { return }
        
        if (!isSongLooping){
            isSongLooping = true
            player.numberOfLoops = Int.max
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.isRepeatingIcon)
            songControls.repeatButton.tintColor = .systemRed
        } else {
            isSongLooping = false
            player.numberOfLoops = 0
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
            songControls.repeatButton.tintColor = .black
        }
        
    }
    
    @objc private func randomSong(){
        guard let _ = SongPlayerManager.shared.player else { return }
        
        let randomNumber = Int.random(in: 0...(songs.count - 1))
        updateView(with: songs[randomNumber], songs: songs, selectedIndex: randomNumber)
    }
    
    @objc private func addSongToFavourites(){
        let isSongInFavourites = FileManagerHelper.isSongInFavourites(title: songs[indexSelectedSong].title!)
        
        let favouriteIcon: String
        
        if (isSongInFavourites){
            FavoritesManager.shared.deleteSong(song: songs[indexSelectedSong])
            favouriteIcon = DGSongControl.noFavouriteIcon
        } else {
            FavoritesManager.shared.addSong(song: songs[indexSelectedSong])
            favouriteIcon = DGSongControl.favouriteIcon
        }
        
        FileManagerHelper.addSongToFavourites(title: song.title!)
        changeAddToFavouriteButtonSymbol(systemName: favouriteIcon)
    }
    
    @objc private func showSongOptions(){
        navigationController?.pushViewController(songOptions, animated: true)
    }
    
    func progressSliderChanged(to value: Float) {}
    func volumeSliderChanged(to value: Float){}
    
    
    private func startProgressTime(){
        let manager = SongPlayerManager.shared
        
        if (enableProgressSlider){
            timerSong?.invalidate()
            timerSong = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self, let player = SongPlayerManager.shared.player else { return }

                // Si el usuario está moviendo el slider, no sobrescribir su valor
                if self.songControls.progressSlider.isTracking { return }

                self.songControls.progressSlider.value = Float(player.currentTime / player.duration)
                self.songControls.songCurrentLabel.text = self.formatTime(time: player.currentTime)
                
                self.mediaPlayerInfo()
            }
        } else {
            self.songControls.progressSlider.value = 0
            self.songControls.songCurrentLabel.text = "0:00"
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
        let activateBackground = (song.image == nil)
        let image = song.image ?? UIImage(systemName: "music.note")
        
        albumArtImageView = DGSongImagePlayer(imageSong: image!, activateBackground: activateBackground)
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
    
    private func enableButtonsWhenBrowsing() {
        songControls.backwardButton.isEnabled = true
        songControls.forwardButton.isEnabled = true
        songControls.randomSongButton.isEnabled = true
    }
    
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func resetTimers() {
        timerSong?.invalidate()
        guard let player = SongPlayerManager.shared.player else {
            print("⚠️ Error: AVAudioPlayer no está inicializado aún.")
            return
        }

        if enableProgressSlider {
            songControls.songCurrentLabel.text = formatTime(time: player.currentTime)
            songControls.progressSlider.value = Float(player.currentTime / player.duration)
            songControls.songDurationLabel.text = formatTime(time: player.duration)
            
            startProgressTime()
        } else {
            songControls.songCurrentLabel.text = "0:00"
            songControls.progressSlider.value = 0
            songControls.songDurationLabel.text = song.duration
        }
    }
    
    private func resetAudioPlayer(){
        guard var player = SongPlayerManager.shared.player else { return }
        
        player.stop()
        activateAudioPlayer()
        player = SongPlayerManager.shared.player!
        player.prepareToPlay()
        enableProgressSlider = true
        
        isSongLooping = false
        player.numberOfLoops = 0
    }

    
    private func configure() {
        // Añadir el controlador hijo
        addChild(albumArtImageView)
        view.addSubview(albumArtImageView.view)
        albumArtImageView.didMove(toParent: self)

        // Resto de vistas
        view.addSubview(songTitle)
        view.addSubview(songControls.addToFavouriteButton)

        addChild(songControls)
        view.addSubview(songControls.view)
        songControls.didMove(toParent: self)

        // IMPORTANTE: desactivar autoresizing
        albumArtImageView.view.translatesAutoresizingMaskIntoConstraints = false
        songTitle.translatesAutoresizingMaskIntoConstraints = false
        songControls.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 🔹 Imagen del álbum (centrada)
            albumArtImageView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArtImageView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            albumArtImageView.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            albumArtImageView.view.heightAnchor.constraint(equalTo: albumArtImageView.view.widthAnchor),

            // 🔹 Título de la canción (debajo de la imagen, alineado a la izquierda)
            songTitle.topAnchor.constraint(equalTo: albumArtImageView.view.bottomAnchor, constant: 15),
            songTitle.leadingAnchor.constraint(equalTo: albumArtImageView.view.leadingAnchor),

            // 🔹 Botón de favorito (alineado a la derecha del álbum)
            songControls.addToFavouriteButton.centerYAnchor.constraint(equalTo: songTitle.centerYAnchor),
            songControls.addToFavouriteButton.trailingAnchor.constraint(equalTo: albumArtImageView.view.trailingAnchor),

            // 🔹 Controles (debajo del título)
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
        for setting in songOptions.options {
            switch (setting.songSetting){
            case .Looping:
                updateLoopingOptions()
                break
            }
        }
    }
    
    private func updateLoopingOptions(){
        let isLoopingEnableBySettings = songOptions.options[SongOptionsVC.loopingSettingNumber].isOptionEnabled
        
        isSongLooping = isLoopingEnableBySettings
        
        let numberOfLoops = (isLoopingEnableBySettings) ? Int.max : 0
        let repeatIcon = (isLoopingEnableBySettings) ? DGSongControl.isRepeatingIcon : DGSongControl.repeatIcon
        
        SongPlayerManager.shared.player?.numberOfLoops = numberOfLoops
        songControls.changeRepeatButtonSymbol(systemName: repeatIcon)
    }
    
    private func mediaPlayerInfo(){
        guard let player = SongPlayerManager.shared.player else { return }
        
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: song.title ?? "Unknown song",
            MPMediaItemPropertyPlaybackDuration: player.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime,
            MPNowPlayingInfoPropertyPlaybackRate: (player.isPlaying) ? 1.0: 0.0
        ]
        
        if let image = song.image {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image}
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupRemoteCommandCenter(){
        guard !SongPlayerManager.shared.remoteCommandsConfigured else { return }
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] _ in
            self.playPauseSong()
            mediaPlayerInfo()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            self.playPauseSong()
            mediaPlayerInfo()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] _ in
            self.changeToNextSong()
            mediaPlayerInfo()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] _ in
            self.changeToPreviousSong()
            mediaPlayerInfo()
            return .success
        }
        
        SongPlayerManager.shared.remoteCommandsConfigured = true
    }
    
    private func updateView(with song: Song, songs: [Song], selectedIndex: Int){
        enableProgressSlider = (SongPlayerManager.shared.song?.title == song.title)
        self.song = song
        self.songs = songs
        self.indexSelectedSong = selectedIndex
        
        resetAudioPlayer()
        resetTimers()
        SongPlayerManager.shared.player?.play()
        
        if (songs.count > 1){
            enableButtonsWhenBrowsing()
        } else {
            disableButtonsWhenSearching()
        }
        
        let activateBackground = (song.image != nil)
        albumArtImageView.updateImage(image: (song.image ?? UIImage(systemName: "music.note"))!, activateBackground: activateBackground)
        updateSongTitle(with: song.title)
        
        let loopingIcon = (SongPlayerManager.shared.song?.title == self.song.title && isSongLooping) ? DGSongControl.isRepeatingIcon : DGSongControl.repeatIcon
        
        songControls.changePauseButtonSymbol(systemName: DGSongControl.pauseIcon)
        songControls.changeRepeatButtonSymbol(systemName: loopingIcon)
        
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
