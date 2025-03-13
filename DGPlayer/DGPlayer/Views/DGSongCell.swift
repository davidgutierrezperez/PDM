//
//  DGSongCell.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class DGSongCell: UICollectionViewCell {
    
    static let reusableIdentifier = "DGSongCell"
    
    private let songTitle = UILabel()
    private let songArtist = UILabel()
    private let songBand = UILabel()
    private let songImage = UIImageView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(song: Song) {
        songTitle.text = song.title
        songImage.image = song.image
        
        if (songImage.image == nil){
            songImage.image = UIImage(systemName: "music.note")
        }

        // 🔹 Ajustar imagen para tamaño uniforme
        songImage.contentMode = .scaleAspectFill
        songImage.clipsToBounds = true
        songImage.layer.cornerRadius = 6
        songImage.layer.masksToBounds = true

        // Configuración de estilos
        songTitle.font = UIFont.boldSystemFont(ofSize: 16)

        // Fondo gris claro con bordes redondeados
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        // Agregar subviews
        contentView.addSubview(songImage)
        contentView.addSubview(songTitle)

        // Desactivar AutoResizingMask
        songImage.translatesAutoresizingMaskIntoConstraints = false
        songTitle.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        NSLayoutConstraint.activate([
            // 🔹 Imagen con tamaño uniforme
            songImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            songImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            songImage.widthAnchor.constraint(equalToConstant: 35),  // 🔥 Tamaño más pequeño
            songImage.heightAnchor.constraint(equalToConstant: 35),

            // 🔹 Título de la canción (centrado verticalmente)
            songTitle.leadingAnchor.constraint(equalTo: songImage.trailingAnchor, constant: 10),
            songTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            songTitle.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    

    
    
    
    
}
