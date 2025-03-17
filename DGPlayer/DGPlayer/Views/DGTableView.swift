//
//  DGTableView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 12/3/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class DGTableView: UITableViewController {
    
    private var songs : [Song] = []

    
    init(songs: [Song]){
        self.songs = songs
    
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.register(DGSongCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
    }
    
    func setSongs(songs: [Song]){
        self.songs = songs
        tableView.reloadData()
    }
    
    func addSong(song: Song){
        self.songs.append(song)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DGSongCell
        let song = songs[indexPath.item]
        cell.configure(song: song)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    


}
