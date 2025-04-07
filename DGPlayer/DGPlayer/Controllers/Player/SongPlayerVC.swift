//
//  SongPlayerVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit
import AVFoundation
import MediaPlayer


/// Clase que gestiona la reproducción de una canción
class SongPlayerVC: UIViewController, DGSongControlDelegate {
    
    /// Instancia de la clase para ser llamada de forma externa
    static var shared: SongPlayerVC?
    
    /// Canción actualmente en reproducción
    private var song: Song
    
    /// Conjunto de canciones cargadas por el reproductor
    private var songs: [Song]
    
    /// Indice la canción actualmente en reproduccción
    private var indexSelectedSong: Int
    
    /// Imagen de la canción actualmente en reproducción
    private var albumArtImageView: DGSongImagePlayer!
    
    /// Título de la canción actualmente en reproducción
    private var songTitle: UILabel!
    
    /// Interfaz de los simbolos de control de canción
    private var songControls = DGSongControl()
    
    /// Boton de configuración de opciones de la canción
    private var optionButton = UIBarButtonItem()
    
    /// Ajustes de configuración de la canción
    private var songSettings = SongSettingVC()
    
    /// Indica si el slider debe activarse
    private var enableProgressSlider = true
    
    /// Indica si el temporizador de la canción ha sido activado
    private var timerSong: Timer!
    
    /// Contructor por defecto de la clase SongPlayerVC. Se inicializan la canciones
    /// a cargar por el reproductor de música y se indica la canción actual a reproducir. Además,
    /// se configuran los botones, el título de la canción, el slider y el resto de la interfaz de la vista.
    /// - Parameters:
    ///   - indexSelectedSong: indice de la canción a reproducir.
    ///   - songs: canciones a cargar por el reproductor de música.
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
    
    
    /// Presenta el reproductor de música desde una vista padre y se configuran las canciones a cargar por
    /// el reproductor y la canción actual a reproducir.
    /// - Parameters:
    ///   - parent: vista padre desde la que se presenta el reproductor.
    ///   - song: canción actual a reproducir.
    ///   - songs: canciones a cargar por el reproductor.
    ///   - selectedSong: indice de la canción actual a reproducir.
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
    
    /// Destructor por defecto. Se elimina la instancia del reproductor de música
    /// para liberar recursos.
    deinit {
        SongPlayerVC.shared = nil
    }

    /// Eventos a ocurrir cuando se carga la vista por primera vez. Se configuran los elementos
    /// de navegación, el reproductor de música y la sesión de audio en segundo plano.
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationItem.backBarButtonItem?.tintColor = .systemRed
        navigationItem.largeTitleDisplayMode = .never
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationItem.backButtonTitle = nil
        
        fondo()
        updateFavoriteIcon()
        
        if (!SongPlayerManager.shared.isSongPlayerConfigured){
            SongPlayerManager.shared.configureAudioSession()
            activateAudioPlayer()
        }
        setupRemoteCommandCenter()
    }
    
    
    /// Eventos a ocurrir cuando la vista se carga de nuevo.
    /// - Parameter animated: indica si se debe animar la aparición de la vista.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SongPlayerFooterVC.shared.hide()
        
        updateFavoriteIcon()
        updateOptions()
        
        // En caso de que solo haya una canción disponible,
        // desabilita los botones para pasar de canción.
        if (songs.count == 1){
            disableButtonsWhenSearching()
        }
        
        tabBarController?.tabBar.isHidden = true
    }
    
    
    /// Eventos a ocurrir cuando la vista desaparece.
    /// - Parameter animated: indica si se debe animar la desaparación de la vista.
    override func viewWillDisappear(_ animated: Bool) {
        songControls.changePauseButtonSymbol(systemName: DGSongControl.pauseIcon)
        SongPlayerFooterVC.shared.setAlpha(value: 1)
    }
    
    /// Configura el fondo de la vista en forma de degradado.
    private func fondo() {
        let gradientLayer = CAGradientLayer()
        
        // Naranja arriba, oscuro abajo
        gradientLayer.colors = [
            UIColor(red: 240/255, green: 153/255, blue: 102/255, alpha: 1).cgColor,   // Naranja suave
            UIColor(red: 102/255, green: 51/255, blue: 0/255, alpha: 1).cgColor        // Marrón oscuro
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // De arriba
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Hacia abajo
        gradientLayer.frame = view.bounds

        let gradientView = UIView(frame: view.bounds)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        // Efecto blur sutil
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds

        view.addSubview(gradientView)
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
    }
    
    
    /// Activa el reproductor de audio con la canción a reproducir y le indica las canciones a cargar
    /// para su posible reproducción. También inicializa los controles de la canción para su manejo
    /// en segundo plano de forma externa a la aplicación.
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
    
    
    /// Inicia, continua o pausa la canción en función de su estado actual. Además, actualiza el símbolo
    /// de reproducción de canción.
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
        if let tabBar = self.tabBarController {
            SongPlayerFooterVC.shared.show(in: tabBar)
        }
        mediaPlayerInfo()
    }
    
    
    /// Cambia a la siguiente canción de la lista de canciones disponibles.
    @objc private func changeToNextSong(){
        indexSelectedSong = (indexSelectedSong == songs.count - 1) ? 0 : (indexSelectedSong + 1)
        updateView(with: songs[indexSelectedSong], songs: songs, selectedIndex: indexSelectedSong)
    }
    
    
    /// Cambia a la anterior canción de la lista de canciones disponibles.
    @objc private func changeToPreviousSong(){
        indexSelectedSong = (indexSelectedSong == 0) ? (songs.count - 1) : (indexSelectedSong - 1)
        updateView(with: songs[indexSelectedSong], songs: songs, selectedIndex: indexSelectedSong)
    }
    
    
    /// Permite modificar el valor del slider de forma interactiva y actualiza la reproducción
    /// de la canción para que coincida con el valor del slider.
    /// - Parameter sender: slider cuyo valor ha sido modificado interactívamente.
    @objc private func sliderChanged(_ sender: UISlider){
        guard let player = SongPlayerManager.shared.player else { return }
        
        let newTime = TimeInterval(sender.value) * player.duration
        player.currentTime = newTime
        
        songControls.songCurrentLabel.text = formatTime(time: newTime)
    }
    
    
    /// Activa la reproducción en bucle de una canción.
    @objc private func repeatSong(){
        let manager = SongPlayerManager.shared
        
        if manager.reproduceRandomSongAsNext {
            manager.configureSimpleReproduction(activated: true)
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
            songControls.repeatButton.tintColor = .white
            songControls.randomSongButton.tintColor = .white
            return
        }
        
        let isSimpleReproductionActivated = manager.simpleReproduction
        let isReproduceAllPlaylistActivated = manager.reproduceAllPlaylist
        let isLoopingSong = manager.isLoopingSong
        
        songControls.changeRandomSongTint(activated: false)
        
        if (isSimpleReproductionActivated){
            manager.configureReproduceAllPlaylist(activated: true)
            songControls.repeatButton.tintColor = .systemRed
            songControls.randomSongButton.tintColor = .white
            
            return
        } else if (isReproduceAllPlaylistActivated){
            manager.configureLoopingSong(activated: true)
            
            SongPlayerManager.shared.player?.numberOfLoops = Int.max
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.isRepeatingIcon)
            songControls.repeatButton.tintColor = .systemRed
            songControls.randomSongButton.tintColor = .white

            return
        } else if (isLoopingSong){
            manager.configureSimpleReproduction(activated: true)
            
            SongPlayerManager.shared.player?.numberOfLoops = 0
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
            songControls.repeatButton.tintColor = .white
            songControls.randomSongButton.tintColor = .white
            
            return
        }

        
    }
    
    
    /// Establece que la siguiente canción a reproducir deberá ser aleatoria.
    @objc private func randomSong(){
        let manager = SongPlayerManager.shared

        if manager.reproduceRandomSongAsNext {
            manager.configureSimpleReproduction(activated: true)
            songControls.changeRandomSongTint(activated: false)
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
            songControls.repeatButton.tintColor = .white
        } else {
            manager.configureReproduceRandomSongAsNext(activated: true)
            songControls.changeRandomSongTint(activated: true)
            songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
            songControls.repeatButton.tintColor = .white
        }
    }

    
    
    /// Añade una canción a favoritos.
    @objc private func addSongToFavourites(){
        let isSongInFavourites = FileManagerHelper.isSongInFavourites(title: songs[indexSelectedSong].title!)
        let favoriteIconTintColor: UIColor = (isSongInFavourites) ? .systemRed : .white
        
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
        songControls.addToFavouriteButton.tintColor = favoriteIconTintColor
    }
    
    
    /// Muestra la vista de opciones de configuración de la canción.
    @objc private func showSongOptions(){
        let vc = SongSettingVC()
        vc.settings = songSettings.settings
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// Muestra la vista de selección de playlists para añadir una canción a la playlist seleccionada.
    @objc private func addSongToPlaylist(){
        let playlistSelector = PlaylistSelectorVC(song: song)
        
        playlistSelector.onSelectedPlaylist = { [weak self] newSong in
            guard let self = self else { return }
        }
        
        let nv = UINavigationController(rootViewController: playlistSelector)
        present(nv, animated: true)
    }
    
    
    /// Modifica el valor del slider que muestra el tiempo de reproducción de la canción.
    /// - Parameter value: nuevo valor del slider.
    func progressSliderChanged(to value: Float) {}
    
    
    /// Modifica el valor del slider que muestra el volumen de la canción que se está reproduciendo.
    /// - Parameter value: nuevo valor del slider.
    func volumeSliderChanged(to value: Float){}
    
    
    /// Activa el temporizador para la reproducción de la canción y actualiza el valor del slider
    /// en función del tiempo que lleve la canción reproduciéndose.
    private func startProgressTime(){
        if (enableProgressSlider){
            timerSong?.invalidate()
            timerSong = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self, let player = SongPlayerManager.shared.player else { return }

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

    
    /// Actualiza el símbolo del boton de favoritos en función de su estado actual.
    /// - Parameter systemName: nuevo símbolo que tendrá el boton de favoritos.
    private func changeAddToFavouriteButtonSymbol(systemName: String){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        songControls.addToFavouriteButton.setImage(UIImage(systemName: systemName, withConfiguration: largeConfig), for: .normal)
    }
    
    
    /// Actualiza el boton de favoritos en función de si la canción está catalogada como favorita.
    private func updateFavoriteIcon(){
        if (FileManagerHelper.isSongInFavourites(title: songs[indexSelectedSong].title!)){
            changeAddToFavouriteButtonSymbol(systemName: DGSongControl.favouriteIcon)
        } else {
            changeAddToFavouriteButtonSymbol(systemName: DGSongControl.noFavouriteIcon)
        }
    }

    /// Configura el slider y establece sus funciones asociadas.
    private func configureProgressSlider(){
        songControls.progressSlider.isUserInteractionEnabled = true
        songControls.progressSlider.isContinuous = true
        
        songControls.progressSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }

    
    /// Configura los botones de la vista y establece sus funciones asociadas.
    private func configureButtons(){
        songControls.pauseButton.addTarget(self, action: #selector(playPauseSong), for: .touchUpInside)
        songControls.backwardButton.addTarget(self, action: #selector(changeToPreviousSong), for: .touchUpInside)
        songControls.forwardButton.addTarget(self, action: #selector(changeToNextSong), for: .touchUpInside)
        songControls.repeatButton.addTarget(self, action: #selector(repeatSong), for: .touchUpInside)
        songControls.randomSongButton.addTarget(self, action: #selector(randomSong), for: .touchUpInside)
        songControls.addToFavouriteButton.addTarget(self, action: #selector(addSongToFavourites), for: .touchUpInside)
        songControls.addToPlaylistButton.addTarget(self, action: #selector(addSongToPlaylist), for: .touchUpInside)
        
        if (song.isFavourite){
            changeAddToFavouriteButtonSymbol(systemName: DGSongControl.favouriteIcon)
        }
        
        configureOptionButton()
    }
    
    /// Configura el boton de configuración de opciones.
    private func configureOptionButton(){
        optionButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showSongOptions))
        optionButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = optionButton
    }
    
    /// Configura la imagen asociada a la canción que se mostrará en la vista.
    private func configureImageSong(){
        let activateBackground = (song.image == nil)
        let image = song.image ?? UIImage(systemName: "music.note")
        
        albumArtImageView = DGSongImagePlayer(imageSong: image!, activateBackground: activateBackground)
    }
    
    
    /// Configura el título de la canción y el número de caracteres que puede mostrar.
    /// - Parameter title: titulo de la canción.
    private func configureSongTitle(title: String){
        let newSongTitle = UILabel()
        let maxCharacters = 35
        if title.count > maxCharacters {
            let index = song.title!.index(title.startIndex, offsetBy: maxCharacters)
            newSongTitle.text = String(title[..<index]) + "..."
        } else {
            newSongTitle.text = title
        }
        newSongTitle.font = UIFont.boldSystemFont(ofSize: 16)
        newSongTitle.textColor = .white
        
        
        newSongTitle.translatesAutoresizingMaskIntoConstraints = false
        
        songTitle = newSongTitle
    }
    
    
    /// Actualiza el titulo de la canción y establece el número de caracteres que puede mostrar.
    /// - Parameter title: título de la canción.
    private func updateSongTitle(with title: String?) {
        guard let title = title, !title.isEmpty else {
            songTitle?.text = "Unknown Title"
            return
        }
        

        let maxCharacters = 35
        if title.count > maxCharacters {
            let index = title.index(title.startIndex, offsetBy: maxCharacters)
            songTitle?.text = String(title[..<index]) + "..."
        } else {
            songTitle?.text = title
        }
    }
    
    
    /// Desabilida los botones de paso de canciones.
    private func disableButtonsWhenSearching(){
        songControls.backwardButton.isEnabled = false
        songControls.forwardButton.isEnabled = false
        songControls.randomSongButton.isEnabled = false
    }
    
    /// Habilita los botones de paso de canciones.
    private func enableButtonsWhenBrowsing() {
        songControls.backwardButton.isEnabled = true
        songControls.forwardButton.isEnabled = true
        songControls.randomSongButton.isEnabled = true
    }
    
    
    /// Proporciona un *string* a partir de un valor de entrada en formato *TimeInterval*.
    /// - Parameter time: tiempo en formato *TimeInterval*
    /// - Returns: devuelve un *string* equivalente al tiempo proporcionada.
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// Resetea los temporizadores asociados a la canción y el progreso del slider.
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
    
    /// Resetea el reproductor de música y detiene la reproducción de audio.
    private func resetAudioPlayer(){
        guard var player = SongPlayerManager.shared.player else { return }
        
        player.stop()
        activateAudioPlayer()
        player = SongPlayerManager.shared.player!
        player.prepareToPlay()
        enableProgressSlider = true
        
        player.numberOfLoops = 0
    }
    
    
    /// Resetea el reproductor de audio, los temporizadores asociados y
    /// detiene la reproducción de música. Además, prepara al reproductor
    /// para la siguiente reproducción de audio.
    private func resetEverythingAndPlay(){
        resetAudioPlayer()
        resetTimers()
        SongPlayerManager.shared.player?.play()
    }

    
    /// Configura la interfaz de la vista.
    private func configure() {
        // Añadir el controlador hijo
        addChild(albumArtImageView)
        view.addSubview(albumArtImageView.view)
        albumArtImageView.didMove(toParent: self)

        // Resto de vistas
        view.addSubview(songTitle)
        view.addSubview(songControls.addToFavouriteButton)
        view.addSubview(songControls.addToPlaylistButton)

        addChild(songControls)
        view.addSubview(songControls.view)
        songControls.didMove(toParent: self)

        // IMPORTANTE: desactivar autoresizing
        albumArtImageView.view.translatesAutoresizingMaskIntoConstraints = false
        songTitle.translatesAutoresizingMaskIntoConstraints = false
        songControls.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            albumArtImageView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumArtImageView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            albumArtImageView.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            albumArtImageView.view.heightAnchor.constraint(equalTo: albumArtImageView.view.widthAnchor),

            songTitle.topAnchor.constraint(equalTo: albumArtImageView.view.bottomAnchor, constant: 15),
            songTitle.leadingAnchor.constraint(equalTo: albumArtImageView.view.leadingAnchor),

            songControls.addToFavouriteButton.centerYAnchor.constraint(equalTo: songTitle.centerYAnchor),
            songControls.addToFavouriteButton.trailingAnchor.constraint(equalTo: albumArtImageView.view.trailingAnchor),

            songControls.addToPlaylistButton.centerYAnchor.constraint(equalTo: songControls.addToFavouriteButton.centerYAnchor),
            songControls.addToPlaylistButton.trailingAnchor.constraint(equalTo: songControls.addToFavouriteButton.leadingAnchor, constant: -15),

            songControls.view.topAnchor.constraint(equalTo: songTitle.bottomAnchor, constant: 40),
            songControls.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            songControls.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songControls.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    /// Actualiza las opciones de la canción.
    private func updateOptions(){
        for setting in songSettings.settings {
            switch (setting.type){
            case .toggle(let isOn):
                checkToggleSettings(id: setting.id, isOn: isOn)
                break
            case .slider(_, _, let current, _):
                checkSliderSettings(id: setting.id, current: current)
                break
            }
        }
    }
    
    /// Comprueba las distintas opciones a configurar mediante botones.
    /// - Parameters:
    ///   - id: identificador del ajuste.
    ///   - isOn: indica si la configuración está activa.
    ///   - foundActiveSetting: indica si se ha activado alguna configuración.
    private func checkToggleSettings(id: SettingID, isOn: Bool){
        if (id == .looping && isOn){
            updateLoopingSetting()
        } else if (id == .randomSong && isOn){
            updateRandomSongLetting()
        }
    }
    
    /// Actualiza la configuración de reproducción en bucle.
    private func updateLoopingSetting(){
        SongPlayerManager.shared.configureLoopingSong(activated: true)
        
        SongPlayerManager.shared.player?.numberOfLoops = Int.max
        songControls.changeRepeatButtonSymbol(systemName: DGSongControl.isRepeatingIcon)
        songControls.repeatButton.tintColor = .systemRed
        songControls.randomSongButton.tintColor = .white
    }
    
    /// Actualiza la configuración de reproducción aleatoria.
    private func updateRandomSongLetting(){
        SongPlayerManager.shared.configureReproduceRandomSongAsNext(activated: true)
        songControls.changeRandomSongTint(activated: true)
        songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
        songControls.repeatButton.tintColor = .white
    }
    
    /// Actualiza la configuración de reproducción simple
    private func updateSimpleReproductionSetting(){
        SongPlayerManager.shared.configureSimpleReproduction(activated: true)
        
        SongPlayerManager.shared.player?.numberOfLoops = 0
        songControls.changeRepeatButtonSymbol(systemName: DGSongControl.repeatIcon)
        songControls.repeatButton.tintColor = .white
        songControls.randomSongButton.tintColor = .white
    }
    
    /// Comprueba las distintas opciones de configuración medinate *sider*.
    /// - Parameters:
    ///   - id: identificador de ajuste.
    ///   - current: valor actual del slider.
    private func checkSliderSettings(id: SettingID, current: Float){
        switch (id){
        case .volume:
            updatePlayerVolume(volume: current)
            break
        case .rate:
            updatePlayerRate(rate: current)
            break
        default:
            break
        }
    }
    
    /// Actualiza el volumen de la canción.
    /// - Parameter volume: volumen actual de la canción.
    private func updatePlayerVolume(volume: Float){
        SongPlayerManager.shared.player?.volume = volume
    }
    
    /// Actualiza la velocidad de reproducción de la canción.
    /// - Parameter rate: velocidad de la canción.
    private func updatePlayerRate(rate: Float){
        let isRateEnabled = songSettings.isRateEnabled()
        let newRate = (isRateEnabled) ? rate : 1
        
        print("New rate:", newRate)
        
        SongPlayerManager.shared.player?.enableRate = true
        SongPlayerManager.shared.player?.rate = newRate
    }
    
    
    /// Establece la información de la canción que se mostrará en el reproductor de música a
    /// utilizar de forma externa a la aplicación, es decir, la información que se mostrará en el
    /// reproductor a emplear cuando se reproduce música en segundo plano.
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
    
    /// Establece los controles del reproductor de música para su uso de forma externa a la aplicación, es decir,
    /// para su uso en segundo plano.
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
    
    
    /// Actualiza la vista del reproductor con una nueva canción a reproducir. Además, establece las canciones
    /// que el reproductor podrá reproducir.
    /// - Parameters:
    ///   - song: nueva canción a reproducir.
    ///   - songs: canciones a cargar en el reproductor de música.
    ///   - selectedIndex: índice de la canción actual a reproducir.
    private func updateView(with song: Song, songs: [Song], selectedIndex: Int){
        enableProgressSlider = (SongPlayerManager.shared.song?.title == song.title)
        self.song = song
        self.songs = songs
        self.indexSelectedSong = selectedIndex
        
        let isSameSong = SongPlayerManager.shared.song?.title == song.title
        let isReproducingRandomOrAll = SongPlayerManager.shared.reproduceAllPlaylist ||
                                       SongPlayerManager.shared.reproduceRandomSongAsNext

        if !isSameSong || (isReproducingRandomOrAll && !SongPlayerManager.shared.isLoopingSong) {
            resetEverythingAndPlay()
            
            if (SongPlayerManager.shared.isLoopingSong){
                SongPlayerManager.shared.player?.numberOfLoops = Int.max
            }
        }
        
        if (songs.count > 1){
            enableButtonsWhenBrowsing()
        } else {
            disableButtonsWhenSearching()
        }
        
        let activateBackground = (song.image != nil)
        albumArtImageView.updateImage(image: (song.image ?? UIImage(systemName: "music.note"))!, activateBackground: activateBackground)
        updateSongTitle(with: song.title)
        
        let loopingIcon = (SongPlayerManager.shared.song?.title == self.song.title && SongPlayerManager.shared.isLoopingSong) ? DGSongControl.isRepeatingIcon : DGSongControl.repeatIcon
        let playIcon = (SongPlayerManager.shared.player?.isPlaying == true) ? DGSongControl.pauseIcon : DGSongControl.playIcon
        
        songControls.changePauseButtonSymbol(systemName: playIcon)
        songControls.changeRepeatButtonSymbol(systemName: loopingIcon)
        
        let songIsFavourite = FileManagerHelper.isSongInFavourites(title: song.title!)
        let favouriteIcon = songIsFavourite ? DGSongControl.favouriteIcon : DGSongControl.noFavouriteIcon
        changeAddToFavouriteButtonSymbol(systemName: favouriteIcon)
        updateOptions()

        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        UIView.transition(with: albumArtImageView.view, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

extension SongPlayerVC: AVAudioPlayerDelegate {
    
    /// Establece la siguiente canción a reproducir en función de la configuración
    /// del reproductor de música una vez que la canción actual ha terminado.
    /// - Parameters:
    ///   - player: reproductor de música a utilizar.
    ///   - flag: indica si el resultado de la ejecución de la aplicación ha sido exitoso.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (SongPlayerManager.shared.reproduceAllPlaylist){
            indexSelectedSong = (indexSelectedSong == songs.count - 1) ? 0 : (indexSelectedSong + 1)
        } else if (SongPlayerManager.shared.reproduceRandomSongAsNext){
            indexSelectedSong = Int.random(in: 0...songs.count - 1)
        } else if (SongPlayerManager.shared.simpleReproduction){
            songControls.changePauseButtonSymbol(systemName: DGSongControl.playIcon)
        }
        
        song = songs[indexSelectedSong]
        updateView(with: song, songs: songs, selectedIndex: indexSelectedSong)
    }

}

extension SongPlayerVC: SongSettingVCDelegate {
    func songSettingsDidUpdate(_ updateSettings: [SettingItem]) {
        songSettings.settings = updateSettings
        updateOptions()
    }
}


