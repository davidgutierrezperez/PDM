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
    
    func configure(song: Song){
        songTitle.text = song.title
        songArtist.text = song.artist
        songBand.text = song.band
        songImage.image = song.image ?? UIImage(systemName: "music.note")
        
        contentView.addSubview(songTitle)
        contentView.addSubview(songArtist)
        contentView.addSubview(songBand)
        contentView.addSubview(songImage)
        
        songTitle.translatesAutoresizingMaskIntoConstraints = false
        songArtist.translatesAutoresizingMaskIntoConstraints = false
        songBand.translatesAutoresizingMaskIntoConstraints = false
        songImage.translatesAutoresizingMaskIntoConstraints = false
        
        // 
        NSLayoutConstraint.activate([
                // Imagen
                songImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                songImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                songImage.widthAnchor.constraint(equalToConstant: 50),
                songImage.heightAnchor.constraint(equalToConstant: 50),
                    
                // Título de la canción
                songTitle.leadingAnchor.constraint(equalTo: songImage.trailingAnchor, constant: 10),
                songTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                songTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

                // Artista
                songArtist.leadingAnchor.constraint(equalTo: songTitle.leadingAnchor),
                songArtist.topAnchor.constraint(equalTo: songTitle.bottomAnchor, constant: 2),
                songArtist.trailingAnchor.constraint(equalTo: songTitle.trailingAnchor),
                    
                // Banda (si no hay artista, mostrar esto)
                songBand.leadingAnchor.constraint(equalTo: songTitle.leadingAnchor),
                songBand.topAnchor.constraint(equalTo: songArtist.bottomAnchor, constant: 2),
                songBand.trailingAnchor.constraint(equalTo: songTitle.trailingAnchor),
                songBand.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
    }
    

    
    
    
    
}
