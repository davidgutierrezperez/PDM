//
//  SongPlayerFooterVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 1/4/25.
//

import UIKit

class SongPlayerFooterVC: UIViewController {
    
    static let shared = SongPlayerFooterVC()
    private let footerView = SongPlayerFooterUI()
    
    private init(){
        super.init(nibName: nil, bundle: nil)
        self.view = footerView
        
        footerView.playIcon.addTarget(self, action: #selector(playPauseSongPlayer), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPlayer))
        tap.cancelsTouchesInView = false
        footerView.isUserInteractionEnabled = true
        footerView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let playPauseIcon = (SongPlayerManager.shared.player?.isPlaying == true) ? DGSongControl.pauseIcon : DGSongControl.playIcon
        footerView.changePlaySongIcon(systemName: playPauseIcon)
    }
    
    func updateView(with song: Song){
        footerView.updateView(with: song)
    }
    
    func show(in parent: UIViewController) {
        guard self.parent !== parent else { return } // Evitar añadirlo múltiples veces
        
        // Quitar de otro padre si lo tuviera
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()

        parent.addChild(self)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        parent.view.addSubview(self.view)

        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
            self.view.bottomAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.bottomAnchor),
            self.view.heightAnchor.constraint(equalToConstant: 60)
        ])

        self.didMove(toParent: parent)
    }


    func hide() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @objc private func playPauseSongPlayer(){
        guard let player = SongPlayerManager.shared.player else { return }
        
        if (player.isPlaying){
            player.pause()
            footerView.changePlaySongIcon(systemName: DGSongControl.playIcon)
        } else {
            player.play()
            footerView.changePlaySongIcon(systemName: DGSongControl.pauseIcon)
        }
    }
    
    @objc private func openPlayer(){
        guard let _ = SongPlayerManager.shared.player else { return }
        
        let song = SongPlayerManager.shared.song!
        let songs = SongPlayerManager.shared.songs
        let index = SongPlayerManager.shared.selectedIndex

        SongPlayerVC.present(from: self, with: song, songs: songs, selectedSong: index)
    }

}
