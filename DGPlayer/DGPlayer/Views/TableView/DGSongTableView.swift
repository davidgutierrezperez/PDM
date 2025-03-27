//
//  DGTableView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 12/3/25.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol DGSongTableViewDelegate: AnyObject {
    func didDeleteSong(at index: Int)
}

class DGSongTableView: UITableViewController {
    
    var songs: [Song] = []
    var filteredSongs: [Song] = []
    var isFiltering = false
    
    weak var delegate: DGSongTableViewDelegate?

    init(songs: [Song]) {
        self.songs = songs
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DGCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
    }
    
    func setSongs(songs: [Song]) {
        self.songs = songs
        isFiltering = false
        tableView.reloadData()
    }
    
    func addSong(song: Song) {
        self.songs.append(song)
        tableView.reloadData()
    }
    
    func setFilteredSong(songs: [Song]){
        self.filteredSongs = songs
        isFiltering = true
        tableView.reloadData()
    }
    
    func addFilteredSong(song: Song){
        self.filteredSongs.append(song)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredSongs.count : songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DGCell
        let song = isFiltering ? filteredSongs[indexPath.row] : songs[indexPath.row]
        cell.configure(cellTitle: song.title!, cellImage: song.image)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.didDeleteSong(at: indexPath.row)
        }
    }
    
    func setHeaderView(_ header: UIView) {
        // Importante: necesitamos calcular el tamaño correcto
        header.setNeedsLayout()
        header.layoutIfNeeded()

        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame

        tableView.tableHeaderView = header
    }
    
    
}
