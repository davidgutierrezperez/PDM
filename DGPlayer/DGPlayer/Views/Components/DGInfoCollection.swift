//
//  DGInfoCollection.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

class DGInfoCollection: UIView {
    
    let addToCollectionButton = UIButton()
    let settingCollectionButton = UIButton()
    let randomSongButton = UIButton()
    let playFirstSongCollection = UIButton()
    
    init(image: UIImage?, title: String){
        super.init(frame: .zero)
        
        
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
        
        addToCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        settingCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        randomSongButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addToCollectionButton)
        addSubview(settingCollectionButton)
        addSubview(randomSongButton)
    }
    
    private func setImageToButton(button: UIButton, systemName: String, buttonConfig: UIImage.SymbolConfiguration ){
        button.setImage(UIImage(systemName: systemName, withConfiguration: buttonConfig), for: .normal)
    }
    
    func setupView() {
        backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            // Botón izquierda arriba
            addToCollectionButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            addToCollectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),

            // Botón central arriba
            settingCollectionButton.centerYAnchor.constraint(equalTo: addToCollectionButton.centerYAnchor),
            settingCollectionButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Botón derecha arriba
            randomSongButton.centerYAnchor.constraint(equalTo: addToCollectionButton.centerYAnchor),
            randomSongButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])


    }


}
