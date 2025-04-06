//
//  DGSongImagePlayer.swift
//  DGPlayer
//
//  Created by David Gutierrez on 22/3/25.
//

import UIKit

/// Vista asociada a la imagen de una canción cuando se
/// accede al reproductor de audio.
class DGSongImagePlayer: UIViewController {

    /// Imagen asociada a la canción.
    private var imageSong: UIImageView!
    
    /// Imagen de fondo sobre la que se sobrepondrá la imagen de la canción.
    private var backgroundImage: UIImageView!
    
    /// Indica si se debe mostrar una imagen de fondo sobre la imagen de la canción.
    private var activateBackground: Bool = true
    
    /// Constructor por defecto. Establece la imagen asociada a la canción e indica
    /// si se debe visualizar la imagen de fondo.
    /// - Parameters:
    ///   - imageSong: imagen asociada la canción.
    ///   - activateBackground: índica si se debe visualizar la imagen de fondo.
    init(imageSong: UIImage, activateBackground: Bool){
        super.init(nibName: nil, bundle: nil)
        
        self.imageSong = UIImageView(image: imageSong)
        self.backgroundImage = createBackgroundImage()
        self.activateBackground = activateBackground
    }
    
    /// Eventos a ocurrir cuando la vista se carga por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
    
    /// Crea una imagen de fondo sobre la que se superpone la imagen
    /// asociada a la canción.
    /// - Returns: una vista de imagen con el resultado de superponer la
    /// imagen de la canción a una canción de fondo.
    private func createBackgroundImage() -> UIImageView {
        let backgroundImage = UIImageView()
        
        backgroundImage.backgroundColor = (activateBackground) ? .black : nil
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.clipsToBounds = true
        
        return backgroundImage
    }
    
    /// Actualiza la imagen a mostrar en el reproductor.
    /// - Parameters:
    ///   - image: imagen asociada a la canción.
    ///   - activateBackground: índica si se debe visualizar la imagen de fondo.
    func updateImage(image: UIImage, activateBackground: Bool){
        imageSong.image = image
        self.activateBackground = activateBackground
        
        backgroundImage.backgroundColor = (activateBackground) ? .black : nil
    }
    
    /// Configura el layout de la vista e añade sus elementos.
    private func configure(){
        view.addSubview(backgroundImage)
        view.addSubview(imageSong)
        
        imageSong.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        imageSong.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    
            imageSong.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSong.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageSong.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageSong.heightAnchor.constraint(equalTo: imageSong.widthAnchor) // cuadrada
        ])
    }
    
}
