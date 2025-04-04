import UIKit

protocol DGSongControlDelegate: AnyObject {
    func progressSliderChanged(to value: Float)
    
    func volumeSliderChanged(to value: Float)
}

class DGSongControl: UIViewController {
    
    var songCurrentLabel = UILabel()
    var songDurationLabel = UILabel()
    
    var songDurationTimer: TimeInterval = 0.0
    var songCurrentTimer: TimeInterval = 0.0

    var pauseButton = TouchableButton()
    var backwardButton = TouchableButton()
    var forwardButton = TouchableButton()
    var repeatButton = TouchableButton()
    var randomSongButton = TouchableButton()
    var addToFavouriteButton = TouchableButton()
    var addToPlaylistButton = TouchableButton()
    
    var progressSlider = UISlider()
    
    static var pauseIcon: String = "pause.fill"
    static var playIcon: String = "play.fill"
    static var backwardIcon: String = "backward.end.fill"
    static var forwardIcon: String = "forward.end.fill"
    static var repeatIcon: String = "repeat"
    static var isRepeatingIcon: String = "repeat.1"
    static var randomSongIcon: String = "shuffle"
    static var noFavouriteIcon: String = "heart"
    static var favouriteIcon: String = "heart.fill"
    static var addIcon: String = "plus.circle"
    
    weak var delegate: DGSongControlDelegate? 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = nil
        
        configureButtons()
        configureSongLabels()
        configureSlider()
        configure()
    }
    
    
    
    private func configureSongLabels() {
        songCurrentLabel.text = "0:00"
        songCurrentLabel.font = UIFont.systemFont(ofSize: 14)
        
        songDurationLabel.font = UIFont.systemFont(ofSize: 14)
        
        songDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        songCurrentLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
        let tintColor: UIColor = (isDarkMode) ? .white : .black
        
        pauseButton.tintColor = tintColor
        backwardButton.tintColor = tintColor
        forwardButton.tintColor = tintColor
        repeatButton.tintColor = tintColor
        randomSongButton.tintColor = tintColor
        addToFavouriteButton.tintColor = .systemRed
        addToPlaylistButton.tintColor = .white
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        randomSongButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        addToPlaylistButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func configureSliderByDefault() -> UISlider {
        let slider = UISlider()
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.tintColor = .systemBlue
        slider.isContinuous = true
        
        return slider
    }
    
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
    
    func changePauseButtonSymbol(systemName: String){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold)
        pauseButton.setImage(UIImage(systemName: systemName, withConfiguration: largeConfig), for: .normal)
    }
    
    func changeRepeatButtonSymbol(systemName: String){
        let mediaumConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        repeatButton.setImage(UIImage(systemName: systemName, withConfiguration: mediaumConfig), for: .normal)
    }
    
    func changeRandomSongTint(activated: Bool){
        randomSongButton.tintColor = (activated) ? .systemRed : .black
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        delegate?.progressSliderChanged(to: sender.value)
    }
    
    @objc private func volumeSliderChanged(_ sender: UISlider){
        delegate?.volumeSliderChanged(to: sender.value)
    }
    
    
    private func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func configure() {
        view.addSubview(songCurrentLabel)
        view.addSubview(songDurationLabel)
        view.addSubview(progressSlider)
        view.addSubview(pauseButton)
        view.addSubview(backwardButton)
        view.addSubview(forwardButton)
        view.addSubview(repeatButton)
        view.addSubview(randomSongButton)
        
        /*
        view.addSubview(volumeSlider)
        view.addSubview(noVolumeButton)
        view.addSubview(progressiveVolumeButton)
         */
        
        NSLayoutConstraint.activate([
            // 🔹 Barra de progreso
            progressSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressSlider.heightAnchor.constraint(equalToConstant: 2),

            // 🔹 Tiempo actual (izquierda, alineado con el slider)
            songCurrentLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),
            songCurrentLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor, constant: -20),

            // 🔹 Tiempo total (derecha, alineado con el slider)
            songDurationLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),
            songDurationLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor, constant: -20),

            // 🔹 Botones de control (debajo del slider y timers)
            randomSongButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -180), // 🔹 A la izquierda de backwardButton
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

class TouchableButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = -15 // Aumenta el área 15pt por lado
        let area = bounds.insetBy(dx: margin, dy: margin)
        return area.contains(point)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
