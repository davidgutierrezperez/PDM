//
//  HomeVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import AVFoundation

class HomeVC: SongsVC {
    
    override init() {
        super.init()
        
        let songs = FileManagerHelper.loadSongsFromCoreData()
        tableView.setSongs(songs: songs)
        
        isSearchEnable = true
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func deleteSong(at index: Int){
        let song = tableView.songs[index]
        
        tableView.songs.remove(at: index)
        tableView.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        
        FileManagerHelper.deleteSong(song: song)
    }
    
    private func addSongToTableView(song: Song){
        tableView.addSong(song: song)
    }
    
    private func configureButtons(){
        addTargetToBarButton(boton: addButton, target: self, action: #selector(buttonTupped))
        addTargetToBarButton(boton: enableSearchButton, target: self, action: #selector(enableSearchByButton))
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
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
        if selectedFile.startAccessingSecurityScopedResource() {
            defer { selectedFile.stopAccessingSecurityScopedResource() }
            
            if (FileManagerHelper.handleSelectedAudio(url: selectedFile)){
                let updatedSongs = FileManagerHelper.loadSongsFromCoreData()
                if let newSong = updatedSongs.last {
                    addSongToTableView(song: newSong)
                }
            }
        }
    }
    
}
