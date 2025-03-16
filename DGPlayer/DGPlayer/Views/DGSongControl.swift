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

    var pauseButton = UIButton()
    var backwardButton = UIButton()
    var forwardButton = UIButton()
    var noVolumeButton = UIButton()
    var progressiveVolumeButton = UIButton()
    
    var progressSlider = UISlider()
    var volumeSlider = UISlider()

    
    weak var delegate: DGSongControlDelegate? 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureButtons()
        configureSongLabels()
        configureSlider()
        configureVolumeSlider()
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
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        pauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
        backwardButton.setImage(UIImage(systemName: "backward.fill", withConfiguration: largeConfig), for: .normal)
        forwardButton.setImage(UIImage(systemName: "forward.fill", withConfiguration: largeConfig), for: .normal)
        progressiveVolumeButton.setImage(UIImage(systemName: "speaker.wave.2.fill", withConfiguration: largeConfig), for: .normal)
        noVolumeButton.setImage(UIImage(systemName: "speaker.slash.fill", withConfiguration: largeConfig) ,for: .normal)
        
        pauseButton.tintColor = .systemRed
        backwardButton.tintColor = .systemRed
        forwardButton.tintColor = .systemRed
        noVolumeButton.tintColor = .systemRed
        progressiveVolumeButton.tintColor = .systemRed
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        noVolumeButton.translatesAutoresizingMaskIntoConstraints = false
        progressiveVolumeButton.translatesAutoresizingMaskIntoConstraints = false
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
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.tintColor = .systemRed
        progressSlider.isContinuous = true
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        progressSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    private func configureVolumeSlider(){
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 1
        volumeSlider.value = 0.5
        volumeSlider.tintColor = .systemRed
        volumeSlider.isContinuous = true
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.addTarget(self, action: #selector(volumeSliderChanged(_:)), for: .valueChanged)
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        delegate?.progressSliderChanged(to: sender.value)
    }
    
    @objc private func volumeSliderChanged(_ sender: UISlider){
        delegate?.volumeSliderChanged(to: sender.value)
    }
    
    func changeVolumeIcon(){
        let icon : String
        
        if (volumeSlider.value == 0){
            icon = "speaker.slash.fill"
        } else if (volumeSlider.value > 0 && volumeSlider.value <= 0.33){
            icon = "speaker.wave.1.fill"
        } else if (volumeSlider.value >= 0.34 && volumeSlider.value <= 0.66){
            icon = "speaker.wave.2.fill"
        } else {
            icon = "speaker.wave.3.fill"
        }
        
        progressiveVolumeButton.setImage(UIImage(systemName: icon), for: .normal)
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
        view.addSubview(volumeSlider)
        view.addSubview(noVolumeButton)
        view.addSubview(progressiveVolumeButton)
        
        NSLayoutConstraint.activate([
            // 🔹 Barra de progreso
            progressSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            progressSlider.heightAnchor.constraint(equalToConstant: 2),

            // 🔹 Tiempo actual (izquierda, alineado con el slider)
            songCurrentLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),
            songCurrentLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor, constant: -30),

            // 🔹 Tiempo total (derecha, alineado con el slider)
            songDurationLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),
            songDurationLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor, constant: -30),

            // 🔹 Botones de control (debajo del slider y timers)
            backwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            backwardButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 30),

            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            forwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            forwardButton.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor),

            // 🔹 Volume Slider (dejado como estaba)
            volumeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            volumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            volumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            volumeSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            // 🔹 Botón de volumen mínimo (izquierda del slider)
            noVolumeButton.trailingAnchor.constraint(equalTo: volumeSlider.leadingAnchor, constant: -10),
            noVolumeButton.centerYAnchor.constraint(equalTo: volumeSlider.centerYAnchor),

            // 🔹 Botón de volumen máximo (derecha del slider)
            progressiveVolumeButton.leadingAnchor.constraint(equalTo: volumeSlider.trailingAnchor, constant: 10),
            progressiveVolumeButton.centerYAnchor.constraint(equalTo: volumeSlider.centerYAnchor)
        ])


    }
}
