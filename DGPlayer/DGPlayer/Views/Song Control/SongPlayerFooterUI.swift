//
//  SongPlayerFooterUI.swift
//  DGPlayer
//
//  Created by David Gutierrez on 1/4/25.
//

import UIKit

class SongPlayerFooterUI: UIView {
    
    private var imageSong = UIImageView()
    private var titleSong = UILabel()
    var playIcon = TouchableButton()

    init(){
        super.init(frame: .zero)
        
        setupView()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        print("👉 Tocado: \(String(describing: hitView))")
        return hitView
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changePlaySongIcon(systemName: String){
        playIcon.setImage(UIImage(systemName: systemName), for: .normal)
    }
    
    func updateView(with song: Song){
        imageSong.image = song.image ?? UIImage(systemName: "music.note")!
        titleSong.text = song.title ?? "Unknown song"
        
        let playPauseIcon = (SongPlayerManager.shared.player?.isPlaying == true) ? DGSongControl.pauseIcon : DGSongControl.playIcon
        
        playIcon.setImage(UIImage(systemName: playPauseIcon), for: .normal)
        playIcon.tintColor = .systemRed
    }
    
    private func setupView(){
        addSubview(imageSong)
        addSubview(titleSong)
        addSubview(playIcon)
        
        imageSong.translatesAutoresizingMaskIntoConstraints = false
        titleSong.translatesAutoresizingMaskIntoConstraints = false
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageSong.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageSong.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageSong.widthAnchor.constraint(equalToConstant: 40),
            imageSong.heightAnchor.constraint(equalToConstant: 40),

            playIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            playIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 25),
            playIcon.heightAnchor.constraint(equalToConstant: 25),

            titleSong.leadingAnchor.constraint(equalTo: imageSong.trailingAnchor, constant: 12),
            titleSong.trailingAnchor.constraint(equalTo: playIcon.leadingAnchor, constant: -12),
            titleSong.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
