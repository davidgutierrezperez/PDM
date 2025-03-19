//
//  DGSongCell.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class DGSongCell: UITableViewCell {
    
    static let reusableIdentifier = "DGSongCell"
    
    private let songTitle = UILabel()
    private let songArtist = UILabel()
    private let songBand = UILabel()
    private let songImage = UIImageView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(song: Song) {
        songTitle.text = song.title
        songImage.image = song.image
        songImage.contentMode = .scaleAspectFill
        
        if (songImage.image == nil){
            songImage.image = UIImage(systemName: "music.note")
            songImage.contentMode = .scaleAspectFit
        }

        // Ajustar imagen para tamaño uniforme
        songImage.clipsToBounds = true
        songImage.layer.cornerRadius = 6
        songImage.layer.masksToBounds = true

        // Configuración de estilos
        songTitle.font = UIFont.boldSystemFont(ofSize: 16)

        // Fondo gris claro con bordes redondeados
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
            // 🔹 Imagen ocupa toda la altura y parte del ancho
            songImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            songImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            songImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            songImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),  // 🔥 Ocupa el 25% del ancho
            
            // 🔹 Título centrado verticalmente a la derecha
            songTitle.leadingAnchor.constraint(equalTo: songImage.trailingAnchor, constant: 12),
            songTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            songTitle.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    

    
    
    
    
}
