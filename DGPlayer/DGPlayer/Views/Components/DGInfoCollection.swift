//
//  DGInfoCollection.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

class DGInfoCollection: UIView {
    
    let image = UIImageView()
    let addToCollectionButton = UIButton()
    let settingCollectionButton = UIButton()
    let randomSongButton = UIButton()
    let playFirstSongCollection = UIButton()
    
    init(image: UIImage?, title: String){
        super.init(frame: .zero)
        
        self.image.image = image ?? UIImage(systemName: "music.note")
        configureButtons()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        playFirstSongCollection.tintColor = .systemRed
        
        addToCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        settingCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        randomSongButton.translatesAutoresizingMaskIntoConstraints = false
        playFirstSongCollection.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addToCollectionButton)
        addSubview(settingCollectionButton)
        addSubview(randomSongButton)
        addSubview(playFirstSongCollection)

    }
    
    private func setImageToButton(button: UIButton, systemName: String, buttonConfig: UIImage.SymbolConfiguration ){
        button.setImage(UIImage(systemName: systemName, withConfiguration: buttonConfig), for: .normal)
    }
    
    func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true

        NSLayoutConstraint.activate([
                // 🔹 Imagen arriba del todo
            image.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.heightAnchor.constraint(equalToConstant: 200),

            // 🔹 Botón izquierda (debajo de imagen)
            addToCollectionButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            addToCollectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),

            // 🔹 Botón central
            settingCollectionButton.centerYAnchor.constraint(equalTo: addToCollectionButton.centerYAnchor),
            settingCollectionButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            // 🔹 Botón derecha
            randomSongButton.centerYAnchor.constraint(equalTo: addToCollectionButton.centerYAnchor),
            randomSongButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            // 🔹 Botón play debajo de todos
            playFirstSongCollection.topAnchor.constraint(equalTo: addToCollectionButton.bottomAnchor, constant: 20),
            playFirstSongCollection.centerXAnchor.constraint(equalTo: centerXAnchor),

            // 🔹 Fondo mínimo del header
            playFirstSongCollection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])

    }


}
