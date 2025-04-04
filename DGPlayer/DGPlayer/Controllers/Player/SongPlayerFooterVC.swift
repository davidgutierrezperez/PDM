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
        view.addSubview(footerView)
                footerView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    footerView.topAnchor.constraint(equalTo: view.topAnchor),
                    footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])

        
        footerView.playIcon.addTarget(self, action: #selector(playPauseSongPlayer), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPlayer))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let playPauseIcon = (SongPlayerManager.shared.player?.isPlaying == true) ? DGSongControl.pauseIcon : DGSongControl.playIcon
        footerView.changePlaySongIcon(systemName: playPauseIcon)
    }
    
    private func setFooterViewAsView(){
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: view.topAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        footerView.playIcon.addTarget(self, action: #selector(playPauseSongPlayer), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPlayer))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func updateView(with song: Song){
        footerView.updateView(with: song)
    }
    
    func show(in parent: UIViewController) {
        guard view.superview == nil else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.view.addSubview(view)

        if let tabBar = (parent as? UITabBarController)?.tabBar {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
                view.heightAnchor.constraint(equalToConstant: 60)
            ])
        } else {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.bottomAnchor),
                view.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }

    func setAlpha(value: CGFloat){
        view.alpha = value
    }

    func hide() {
        setAlpha(value: 0)
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
    
    @objc private func openPlayer() {
        print("🔥 openPlayer tapped")

        guard let topVC = UIApplication.topMostViewController() else {
            print("❌ No se pudo obtener el VC superior")
            return
        }

        let song = SongPlayerManager.shared.song!
        let songs = SongPlayerManager.shared.songs
        let index = SongPlayerManager.shared.selectedIndex

        SongPlayerVC.present(from: topVC, with: song, songs: songs, selectedSong: index)
    }


}

extension SongPlayerFooterVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }

        return true
    }

}


