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
        
        let songs = FileManagerHelper.loadSongsFromCoreData()
        tableView.setSongs(songs: songs)
            
        view.addSubview(tableView.tableView)
        configureTableView()
        isSearchEnable = true
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
        
        addTargetToButton(boton: addButton, target: self, action: #selector(buttonTupped))
        addTargetToButton(boton: enableSearchButton, target: self, action: #selector(enableSearchByButton))
    }
    
    override func deleteSong(at index: Int){
        let song = tableView.songs[index]
        FileManagerHelper.deleteSong(song: song)
    }
    
    private func addSongToTableView(song: Song){
        tableView.addSong(song: song)
    }
    
     @objc func buttonTupped(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        
        present(documentPicker, animated: true)
    }
    
    @objc func enableSearchByButton(){
        if (!isSearchEnable){
            navigationItem.searchController = configureSearchController()
            navigationItem.searchController?.isActive = true
            isSearchEnable = true
        } else {
            navigationItem.searchController = nil
            navigationItem.searchController?.dismiss(animated: true)
            isSearchEnable = false
        }
    }
    
}

extension HomeVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        
        print("La ubicación del archivo guardado es: ", FileManagerHelper.getDocumentsDirectory())
        
        if (FileManagerHelper.handleSelectedAudio(url: selectedFile)){
            let updatedSongs = FileManagerHelper.loadSongsFromCoreData()
            if let newSong = updatedSongs.last {
                addSongToTableView(song: newSong)
            }
        }
    }
    
}
