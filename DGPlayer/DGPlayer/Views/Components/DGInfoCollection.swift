//
//  DGInfoCollection.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

class DGInfoCollection: UIViewController {
    
    let imageCollection = UIImageView()
    let titleCollection = UILabel()
    let addToCollectionButton = UIButton()
    let settingCollectionButton = UIButton()
    let randomSongButton = UIButton()
    let playFirstSongCollection = UIButton()
    
    init(image: UIImage?, title: String){
        super.init(nibName: nil, bundle: nil)
        
        imageCollection.image = (image != nil) ? image : UIImage(systemName: "music.note")
        titleCollection.text = title
        
        
        configureButtons()
        configureImageCollection()
        configureTitleCollection()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureButtons(){
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        setImageToButton(button: addToCollectionButton, systemName: "plus.circle", buttonConfig: buttonConfig)
        setImageToButton(button: settingCollectionButton, systemName: "ellipsis", buttonConfig: buttonConfig)
        setImageToButton(button: randomSongButton, systemName: "shuffle", buttonConfig: buttonConfig)
        setImageToButton(button: playFirstSongCollection, systemName: "play.fill", buttonConfig: buttonConfig)
        
        addToCollectionButton.tintColor = .systemRed
        settingCollectionButton.tintColor = .systemRed
        randomSongButton.tintColor = .systemRed
        
        addToCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        titleCollection.translatesAutoresizingMaskIntoConstraints = false
        settingCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        randomSongButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addToCollectionButton)
        view.addSubview(titleCollection)
        view.addSubview(settingCollectionButton)
        view.addSubview(randomSongButton)
    }
    
    private func setImageToButton(button: UIButton, systemName: String, buttonConfig: UIImage.SymbolConfiguration ){
        button.setImage(UIImage(systemName: systemName, withConfiguration: buttonConfig), for: .normal)
    }
    
    private func configureImageCollection(){
        imageCollection.translatesAutoresizingMaskIntoConstraints = false
        imageCollection.tintColor = .systemGray
        
        view.addSubview(imageCollection)
    }
    
    private func configureTitleCollection(){
        titleCollection.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleCollection)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            // Imagen centrada arriba
            imageCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageCollection.widthAnchor.constraint(equalToConstant: 250),
            imageCollection.heightAnchor.constraint(equalTo: imageCollection.widthAnchor),

            // Título debajo de la imagen
            titleCollection.topAnchor.constraint(equalTo: imageCollection.bottomAnchor, constant: 16),
            titleCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Botones alineados horizontalmente debajo del título
            addToCollectionButton.topAnchor.constraint(equalTo: titleCollection.bottomAnchor, constant: 20),
            addToCollectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            settingCollectionButton.centerYAnchor.constraint(equalTo: addToCollectionButton.centerYAnchor),
            settingCollectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            randomSongButton.centerYAnchor.constraint(equalTo: addToCollectionButton.centerYAnchor),
            randomSongButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])

    }


}
