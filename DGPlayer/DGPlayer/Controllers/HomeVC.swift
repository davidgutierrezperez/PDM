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
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
        
        addTargetToButton(boton: addButton, target: self, action: #selector(buttonTupped))
        addTargetToButton(boton: enableSearchButton, target: self, action: #selector(enableSearchByButton))

        navigationItem.searchController = nil
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
            isSearchEnable = true
        } else {
            navigationItem.searchController?.dismiss(animated: true)
            isSearchEnable = false
        }
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
