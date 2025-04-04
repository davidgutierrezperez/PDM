//
//  PlaylistSelectorVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 4/4/25.
//

import UIKit

class PlaylistSelectorVC: PlaylistVC {
    
    private let cancelButton = UIBarButtonItem()
    private let song: Song
    var onSelectedPlaylist: ((Playlist) -> Void)?
    
    init(song: Song){
        self.song = song
        
        super.init()
        
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = nil
        navigationItem.rightBarButtonItems = nil
    }
    
    private func configureButtons(){
        cancelButton.title = "Cancel"
        cancelButton.tintColor = .systemRed
        
        addTargetToBarButton(boton: cancelButton, target: self, action: #selector(dismissVC))
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let playlist = (!self.tableView.isFiltering) ?
                        self.tableView.playlists[indexPath.row] :
                        self.tableView.filteredPlaylist[indexPath.row]
        
        FileManagerHelper.addSongToPlaylist(playlistTitle: playlist.name, song: song)
        
        onSelectedPlaylist?(playlist)
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
