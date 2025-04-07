import UIKit

protocol DGSongControlDelegate: AnyObject {
    func progressSliderChanged(to value: Float)
    
    func volumeSliderChanged(to value: Float)
}

/// Vista asociada a los elementos de control del reproductor de audio.
class DGSongControl: UIViewController {
    /// Texto asociado al tiempo actual de la canción.
    var songCurrentLabel = UILabel()
    
    /// Texto asociado a la duración total de la canción.
    var songDurationLabel = UILabel()
    
    /// Temporizador asociado a la duración total de la canción.
    var songDurationTimer: TimeInterval = 0.0
    
    /// Temporizador asociado al tiempo actual de la canción.
    var songCurrentTimer: TimeInterval = 0.0

    /// Botón de pausa del reproductor de audio.
    var pauseButton = TouchableButton()
    
    /// Botón que permite pasar a la anterior canción.
    var backwardButton = TouchableButton()
    
    /// Botón que permite pasar a la siguiente canción.
    var forwardButton = TouchableButton()
    
    /// Botón que permite activar la reproducción en bucle.
    var repeatButton = TouchableButton()
    
    /// Botón que activa la reproducción aleatoria de canciones.
    var randomSongButton = TouchableButton()
    
    /// Botón que permite añadir una canción a favoritos.
    var addToFavouriteButton = TouchableButton()
    
    /// Botón que permite añadir una canción a una *playlist*.
    var addToPlaylistButton = TouchableButton()
    
    /// Slider de progreso de la canción en reproducción.
    var progressSlider = UISlider()
    
    /// Nombre del símbolo asociado al botón de pausa.
    static var pauseIcon: String = "pause.fill"
    
    /// Nombre del símbolo asociado al botón de reproducir.
    static var playIcon: String = "play.fill"
    
    /// Nombre del símbolo asociado al botón de pasar a la anterior canción.
    static var backwardIcon: String = "backward.end.fill"
    
    /// Nombre del símbolo asociado al botón de pasar a la siguiente canción.
    static var forwardIcon: String = "forward.end.fill"
    
    /// Nombre del símbolo asociado al botón de activar la reproducción en bucle.
    static var repeatIcon: String = "repeat"
    
    /// Nombre del símbolo asociado a que la reproducción en bucle está activada.
    static var isRepeatingIcon: String = "repeat.1"
    
    /// Nombre del símbolo asociado al botón de activar la reproducción aleatoria.
    static var randomSongIcon: String = "shuffle"
    
    /// Nombre del símbolo asociado a una canción que no está catalogada como favorita.
    static var noFavouriteIcon: String = "heart"
    
    /// Nombre del símbolo asociado a una canción que está catalogada coo favorita.
    static var favouriteIcon: String = "heart.fill"
    
    /// Nombre del símbolo asociado al botón de añadir una canción a una *playlist*.
    static var addIcon: String = "plus.circle"
    
    /// Objecto que permite controlar los botones desde una vista superior.
    weak var delegate: DGSongControlDelegate?
    
    /// Eventos a ocurrir cuando la vista se carga por primera vez. Configura los distintos
    /// elemento de la vista.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = nil
        
        configureButtons()
        configureSongLabels()
        configureSlider()
        configure()
    }
    
    /// Configura los textos asociados a los tiempos de canción.
    private func configureSongLabels() {
        songCurrentLabel.text = "0:00"
        songCurrentLabel.font = UIFont.systemFont(ofSize: 14)
        songCurrentLabel.textColor = .white
        
        songDurationLabel.font = UIFont.systemFont(ofSize: 14)
        songDurationLabel.textColor = .white
        
        songDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        songCurrentLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Configura el aspecto visual de los botones de la vista.
    private func configureButtons() {
        let greateConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold)
        let biggerCconfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let mediaumConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        
        pauseButton.setImage(UIImage(systemName: DGSongControl.playIcon, withConfiguration: greateConfig), for: .normal)
        backwardButton.setImage(UIImage(systemName: DGSongControl.backwardIcon, withConfiguration: largeConfig), for: .normal)
        forwardButton.setImage(UIImage(systemName: DGSongControl.forwardIcon, withConfiguration: largeConfig), for: .normal)
        repeatButton.setImage(UIImage(systemName: DGSongControl.repeatIcon, withConfiguration: mediaumConfig), for: .normal)
        randomSongButton.setImage(UIImage(systemName: DGSongControl.randomSongIcon, withConfiguration: mediaumConfig), for: .normal)
        addToPlaylistButton.setImage(UIImage(systemName: DGSongControl.addIcon, withConfiguration: largeConfig), for: .normal)
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let tintColor: UIColor = .white
        
        pauseButton.tintColor = tintColor
        backwardButton.tintColor = tintColor
        forwardButton.tintColor = tintColor
        repeatButton.tintColor = tintColor
        randomSongButton.tintColor = tintColor
        addToFavouriteButton.tintColor = .systemRed
        addToPlaylistButton.tintColor = tintColor
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        randomSongButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        addToPlaylistButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    /// Crea un slider configurado para ser añadido a a vista.
    /// - Returns: slider ya configurado.
    private func configureSliderByDefault() -> UISlider {
        let slider = UISlider()
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.tintColor = .systemBlue
        slider.isContinuous = true
        
        return slider
    }
    
    /// Configura el aspecto visual del slider del reproductor de audio.
    private func configureSlider() {
        let smallThumb = UIImage(systemName: "circle.fill")?.resized(to:CGSize(width: 20, height: 20))
        smallThumb?.withTintColor(UIColor.white)
        
        progressSlider.setThumbImage(smallThumb, for: .normal)
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.tintColor = .systemRed
        progressSlider.isContinuous = true
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        progressSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    /// Permite cambiar el símbolo asociado al botón de pausa.
    /// - Parameter systemName: nombre del símbolo.
    func changePauseButtonSymbol(systemName: String){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold)
        pauseButton.setImage(UIImage(systemName: systemName, withConfiguration: largeConfig), for: .normal)
    }
    
    /// Permite cambiar el símbolo asociado al botón de reproducción en bucle.
    /// - Parameter systemName: nombre del símbolo.
    func changeRepeatButtonSymbol(systemName: String){
        let mediaumConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        repeatButton.setImage(UIImage(systemName: systemName, withConfiguration: mediaumConfig), for: .normal)
    }
    
    /// Permite cambiar el color del botón de reproducción aleatoria en función de su estado.
    /// - Parameter activated: indica si la opción de reproducción aleatoria está activada.
    func changeRandomSongTint(activated: Bool){
        randomSongButton.tintColor = (activated) ? .systemRed : .white
    }
    
    /// Permite cambiar el valor del slider en función de su estado.
    /// - Parameter sender: slider cuyo valor ha sido modificado.
    @objc private func sliderChanged(_ sender: UISlider) {
        delegate?.progressSliderChanged(to: sender.value)
    }
    
    @objc private func volumeSliderChanged(_ sender: UISlider){
        delegate?.volumeSliderChanged(to: sender.value)
    }
    
    
    /// Permite obtener un *String* con un texto equivalente al proporcinado por un objecto
    /// de tipo *TimeInterval*.
    /// - Parameter time: tiempo en formato *TimeInterval*.
    /// - Returns: *String* con un texto equivalente al proporcinado por un objecto
    /// de tipo *TimeInterval*.
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    /// Configura el layout de la vista y añade todos los elementos a esta.
    private func configure() {
        view.addSubview(songCurrentLabel)
        view.addSubview(songDurationLabel)
        view.addSubview(progressSlider)
        view.addSubview(pauseButton)
        view.addSubview(backwardButton)
        view.addSubview(forwardButton)
        view.addSubview(repeatButton)
        view.addSubview(randomSongButton)
        
        NSLayoutConstraint.activate([
            progressSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressSlider.heightAnchor.constraint(equalToConstant: 2),

            songCurrentLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),
            songCurrentLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor, constant: -20),

            songDurationLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),
            songDurationLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor, constant: -20),

            randomSongButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -180),
            randomSongButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            backwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            backwardButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 70),

            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            forwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            forwardButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            repeatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 180), // 🔹 A la derecha de forwardButton
            repeatButton.centerYAnchor.constraint(equalTo: forwardButton.centerYAnchor)
        ])



    }
}

/// Clase que proporciona un botón con algo de *padding* para
/// facilitar su uso.
class TouchableButton: UIButton {
    
    /// Indica si el botón o una posición cercana este ha sido pulsada.
    /// - Parameters:
    ///   - point: punto pulsado por el usuario.
    ///   - event: evento producido al pulsar sobre el botón.
    /// - Returns: devuelve **true** si el area de pulsado es correcta y **false** en caso contrario.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = -15 // Aumenta el área 15pt por lado
        let area = bounds.insetBy(dx: margin, dy: margin)
        return area.contains(point)
    }
}

extension UIImage {
    /// Permite redimensionar una imagen en función de un valor.
    /// - Parameter size: nuevo tamaño de la imagen a redimensionar.
    /// - Returns: imagen redimensionada.
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
