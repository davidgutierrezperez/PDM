//
//  PlaylistCreationView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit
import UniformTypeIdentifiers

/// Vista asociada a la creación de una *Playlist*
class PlaylistCreationView: UIViewController {
    
    /// Objecto que permite la entrada de texto para indicar el nombre de la *playlist*.
    let textfield = UITextField()
    
    /// Botón que indica la finalización de la creación de una *playlist*.
    let okButton = UIBarButtonItem()
    
    /// Botón que indica la cancelación de la creación de una *playlist*.
    let cancelButton = UIBarButtonItem()
    
    /// Botón que permite la selección de una imagen para la *playlist*.
    var imagePickerButton = UIButton()
    
    /// Imagen asociada a la nueva *playlist*.
    var playlistImage = UIImageView()
    
    /// Constructor por defecto del controlador.
    /// - Parameter placeholder: texto a mostrar en el campo de texto.
    init(placeholder: String){
        super.init(nibName: nil, bundle: nil)
        
        textfield.placeholder = placeholder
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
    
    /// Eventos a ocurrir cuando la vista carga por primera vez. Configura los distintos
    /// elementos de la vista y sus layouts.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "New playlist"
        navigationController?.navigationBar.prefersLargeTitles = false

        configureButtons()
        configureTextfield()
        configurePlaylistImage()
        configure()
    }
    
    /// Configura los botones de la vista.
    func configureButtons(){
        okButton.tintColor = .systemRed
        okButton.title = "Ok"
        
        cancelButton.tintColor = .systemRed
        cancelButton.title = "Cancel"
        
        imagePickerButton.setImage(UIImage(systemName: "photo.badge.plus.fill"), for: .normal)
    }
    
    /// Configura el campo de texto de la vista.
    func configureTextfield(){
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 5
        
        let paddingView = UIView(frame: CGRect(x:0,y:0,width: 10, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
    }
    
    /// Configura el recuadro de selección de imagen de la *playlist*.
    func configurePlaylistImage(){
        playlistImage.backgroundColor = UIColor(white: 0.2, alpha: 1.0) // fondo oscuro
        playlistImage.layer.cornerRadius = 10
        playlistImage.clipsToBounds = true
    }
    
    /// Configura el layout de la vista y añade los distintos elementos a mostrar.
    func configure(){
        view.addSubview(textfield)
        view.addSubview(playlistImage)
        view.addSubview(imagePickerButton)
        
        playlistImage.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        textfield.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 🔹 Fondo oscuro centrado
            playlistImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playlistImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            playlistImage.widthAnchor.constraint(equalToConstant: 150),
            playlistImage.heightAnchor.constraint(equalTo: playlistImage.widthAnchor),

            // 🔹 Botón centrado dentro del fondo
            imagePickerButton.centerXAnchor.constraint(equalTo: playlistImage.centerXAnchor),
            imagePickerButton.centerYAnchor.constraint(equalTo: playlistImage.centerYAnchor),
            imagePickerButton.widthAnchor.constraint(equalToConstant: 50),
            imagePickerButton.heightAnchor.constraint(equalToConstant: 50),

            // 🔹 Textfield debajo
            textfield.topAnchor.constraint(equalTo: playlistImage.bottomAnchor, constant: 20),
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            textfield.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
