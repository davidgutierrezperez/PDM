//
//  PlaylistCreationView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit
import UniformTypeIdentifiers

class PlaylistCreationView: UIViewController {
    
    let textfield = UITextField()
    let okButton = UIBarButtonItem()
    let cancelButton = UIBarButtonItem()
    var imagePickerButton = UIButton()
    var playlistImage = UIImageView()
    
    init(placeholder: String){
        super.init(nibName: nil, bundle: nil)
        
        textfield.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configureButtons(){
        okButton.tintColor = .systemRed
        okButton.title = "Ok"
        
        cancelButton.tintColor = .systemRed
        cancelButton.title = "Cancel"
        
        imagePickerButton.setImage(UIImage(systemName: "photo.badge.plus.fill"), for: .normal)
    }
    
    func configureTextfield(){
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 5
        
        let paddingView = UIView(frame: CGRect(x:0,y:0,width: 10, height: textfield.frame.height))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
    }
    
    func configurePlaylistImage(){
        playlistImage.backgroundColor = UIColor(white: 0.2, alpha: 1.0) // fondo oscuro
        playlistImage.layer.cornerRadius = 10
        playlistImage.clipsToBounds = true
    }
    
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
