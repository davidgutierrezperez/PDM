//
//  HomeVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import AVFoundation

class HomeVC: SongsVC {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.addSubview(tableView.tableView)
        configureTableView()
        
        navigationItem.rightBarButtonItem = configureAddButton()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addSongToTableView(song: Song){
        tableView.addSong(song: song)
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
        
        print(FileManagerHelper.getDocumentsDirectory())
        
        if (FileManagerHelper.handleSelectedAudio(url: selectedFile)){
            let updatedSongs = FileManagerHelper.loadSongsFromCoreData()
            if let newSong = updatedSongs.last {
                addSongToTableView(song: newSong)
            }
        }
    }
    
}
