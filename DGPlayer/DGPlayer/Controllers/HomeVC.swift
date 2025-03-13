//
//  HomeVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import AVFoundation

class HomeVC: SongsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.hidesSearchBarWhenScrolling = false
        
        songs = FileManagerHelper.loadSongsFromCoreData()
        filteredSongs = []
        
        collectionView = DGCollectionView(songs: self.songs)
        view.addSubview(collectionView.collectionView)
        configureCollectionView()
        
        navigationItem.rightBarButtonItem = configureAddButton()
    }
    
    private func addSongToCollectionView(song: Song){
        songs.append(song)
        collectionView.addSong(song: song)
    }
    
    private func configureAddButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTupped))
        addButton.tintColor = .systemRed
        
        return addButton
    }
    
    private func configureSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a song"
        
        return searchController
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
        
        if (FileManagerHelper.handleSelectedAudio(url: selectedFile)){
            let updatedSongs = FileManagerHelper.loadSongsFromCoreData()
            if let newSong = updatedSongs.last {
                addSongToCollectionView(song: newSong)
            }
        }
    }
    
}
