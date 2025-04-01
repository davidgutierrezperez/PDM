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
    
    func show(in container: UIView?) {
        guard let container = container else { return }

        view.removeFromSuperview()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: 60)
        ])
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
