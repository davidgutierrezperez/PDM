//
//  DGInfoPlaylist.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

/// Interfaz asociada a la información de una *playlist*.
class DGInfoPlaylist: UIView {
    
    /// Imagen asociada a una *playlist*
    let image = UIImageView()
    
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
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        setImageToButton(button: settingCollectionButton, systemName: "ellipsis", buttonConfig: buttonConfig)
        setImageToButton(button: randomSongButton, systemName: "shuffle", buttonConfig: buttonConfig)
        setImageToButton(button: playFirstSongCollection, systemName: "play.fill", buttonConfig: buttonConfig)
        
        settingCollectionButton.tintColor = .systemRed
        randomSongButton.tintColor = .systemRed
        playFirstSongCollection.tintColor = .systemRed

        settingCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        randomSongButton.translatesAutoresizingMaskIntoConstraints = false
        playFirstSongCollection.translatesAutoresizingMaskIntoConstraints = false
        
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
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true

        NSLayoutConstraint.activate([
            // 🔹 Imagen arriba del todo
            image.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.heightAnchor.constraint(equalToConstant: 200),

            // 🔹 Botón izquierda (debajo de imagen)
            playFirstSongCollection.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            playFirstSongCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),

            // 🔹 Botón central (alineado con el primero)
            settingCollectionButton.centerYAnchor.constraint(equalTo: playFirstSongCollection.centerYAnchor),
            settingCollectionButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            // 🔹 Botón derecha (alineado también)
            randomSongButton.centerYAnchor.constraint(equalTo: playFirstSongCollection.centerYAnchor),
            randomSongButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            // 🔹 (Opcional) margen inferior si necesitas que el header se mida bien
            randomSongButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])


    }


}
