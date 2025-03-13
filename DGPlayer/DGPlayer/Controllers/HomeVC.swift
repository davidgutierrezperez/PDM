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
    private var songs: [Song] = []
    private var filteredSongs : [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        songs = FileManagerHelper.loadSongsFromCoreData()
        filteredSongs = []
        
        collectionView = DGCollectionView(songs: self.songs)
        view.addSubview(collectionView.collectionView)
        configureCollectionView()
        
        navigationItem.rightBarButtonItem = configureAddButton()
        navigationItem.searchController = configureSearchController()
    }
    
    private func addSongToCollectionView(song: Song){
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
    
    func setSongs(songs: [Song]){
        collectionView.setSongs(songs: songs)
        collectionView.collectionView.reloadData()
    }
    
    
    func reloadCollectionView(){
        collectionView.collectionView.reloadData()
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
        
        if (FileManagerHelper.handleSelectedAudio(url: selectedFile)){
            let updatedSongs = FileManagerHelper.loadSongsFromCoreData()
            if let newSong = updatedSongs.last {
                songs.append(newSong)
                addSongToCollectionView(song: newSong)
            }
        }
    }
    
}

extension HomeVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        filteredSongs = songs.filter { $0.title?.lowercased().contains(filter.lowercased()) ?? false }

        setSongs(songs: filteredSongs)
        reloadCollectionView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setSongs(songs: songs)
        reloadCollectionView()
    }
}
