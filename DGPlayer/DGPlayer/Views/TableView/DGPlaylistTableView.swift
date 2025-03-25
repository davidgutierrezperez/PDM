//
//  DGPlaylistTableView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol DGPlaylistTableViewDelegate: AnyObject {
    func deletePlaylist(at index: Int)
}

class DGPlaylistTableView: UITableViewController {
    
    var playlists: [Playlist] = []
    var filteredPlaylist: [Playlist] = []
    var isFiltering: Bool = false
    
    weak var delegate: DGPlaylistTableViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DGCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
    }
    
    init(playlists: [Playlist]){
        self.playlists = playlists
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaylist(playlists: [Playlist]){
        self.playlists = playlists
        isFiltering = false
        
        tableView.reloadData()
    }
    
    func addPlaylist(playlist: Playlist){
        playlists.append(playlist)
        isFiltering = false
        
        tableView.reloadData()
    }
    
    func setFilteredPlaylists(playlists: [Playlist]){
        self.filteredPlaylist = playlists
        isFiltering = true
        tableView.reloadData()
    }
    
    func addFilteredSong(playlist: Playlist){
        self.filteredPlaylist.append(playlist)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isFiltering ? filteredPlaylist.count : playlists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DGCell
        let playlist = isFiltering ? filteredPlaylist[indexPath.row] : playlists[indexPath.row]
        cell?.configure(cellTitle: playlist.name, cellImage: playlist.image)

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.deletePlaylist(at: indexPath.row)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
