//
//  HomeVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {
    
    private var collectionView: DGCollectionView!
    
    // Código generado por IA
    private var songs: [Song] = [
        Song(title: "Creature Comfort", artist: "nil", band: "Arcade Fire", image: UIImage(named: "cover1"), audio: nil),
        Song(title: "Welcome to Your Life", artist: "nil", band: "Grouplove", image: UIImage(named: "cover2"), audio: nil),
        Song(title: "Ophelia", artist: "nil", band: "The Lumineers", image: UIImage(named: "cover3"), audio: nil),
        Song(title: "Electric Feel", artist: "nil", band: "MGMT", image: UIImage(named: "cover4"), audio: nil),
        Song(title: "Why Won't You Make Up Your Mind?", artist: "nil", band: "Tame Impala", image: UIImage(named: "cover5"), audio: nil),
        Song(title: "Lonely Boy", artist: "nil", band: "The Black Keys", image: UIImage(named: "cover6"), audio: nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        collectionView = DGCollectionView(songs: songs)
        
        view.addSubview(collectionView.collectionView)
        configureCollectionView()
        
        navigationItem.rightBarButtonItem = configureAddButton()

    }
    
    private func addSongToCollectionView(song: Song){
        collectionView.addSong(song: song)
    }
    
    private func configureAddButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTupped))
        addButton.tintColor = .systemRed
        
        return addButton
    }
    
    private func configureCollectionView(){
        collectionView.collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func buttonTupped(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        
        present(documentPicker, animated: true)
    }
    
    
}

extension HomeVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        
        let songTitle = selectedFile.lastPathComponent
        let songImage = FileManagerHelper.getImageFromAudioFile(from: selectedFile)
        
        let song = Song(title: songTitle, artist: nil, band: nil, image: songImage, audio: selectedFile)
        FileManagerHelper.saveAudioFile(from: selectedFile)
        
        addSongToCollectionView(song: song)
        
    }
    
   

    
}
