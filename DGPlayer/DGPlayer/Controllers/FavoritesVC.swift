//
//  FavoritesVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class FavoritesVC: SongsVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let songs = FileManagerHelper.loadFavouriteSongsFromCoreData()
        tableView.setSongs(songs: songs)
        
        view.addSubview(tableView.tableView)
        configureTableView()
        isSearchEnable = false
        
        navigationItem.rightBarButtonItems = [addButton, enableSearchButton]
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
