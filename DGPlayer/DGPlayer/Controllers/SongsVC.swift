//
//  SongsViewController.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit

class SongsVC: MainViewsCommonVC {
    
    var tableView: DGSongTableView!
    
    override init(){
        tableView = DGSongTableView(songs: [])
        
        super.init()
    }
    
    init(songs: [Song]){
        tableView = DGSongTableView(songs: songs)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.tableView.delegate = tableView
        
        
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.searchController = configureSearchController()
        view.backgroundColor = .systemBackground
        addButton = configureAddButton()
        enableSearchButton = configureSearchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        let currentSong = SongPlayerManager.shared.song
        if (currentSong != nil){
            SongPlayerFooterVC.shared.updateView(with: currentSong!)
            SongPlayerFooterVC.shared.show(in: self)
        }
    }
    
    func configureSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a song"
        
        return searchController
    }
    
    func configureTableView(){
        view.addSubview(tableView.tableView)
        tableView.tableView.delegate = self
        tableView.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setSongs(songs: [Song]){
        tableView.setSongs(songs: songs)
        tableView.tableView.reloadData()
    }
    
    
    func reloadTableView(){
        tableView.tableView.reloadData()
    }
    
    func deleteSong(at index: Int){}

}

extension SongsVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            reloadTableView()
            return
        }
        
        let filteredSongs = tableView.songs.filter { $0.title?.lowercased().contains(filter) ?? false }
        tableView.setFilteredSong(songs: filteredSongs)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setSongs(songs: tableView.songs)
        reloadTableView()
    }
}

extension SongsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var songsCollection: [Song] = []
        var indexCurrentSong: Int
        
        if let searchText = navigationItem.searchController?.searchBar.text, !searchText.isEmpty {
            songsCollection.append(self.tableView.filteredSongs[indexPath.item])
            indexCurrentSong = 0
        } else {
            songsCollection = self.tableView.songs
            indexCurrentSong = indexPath.item
        }
        
        SongPlayerVC.present(from: self, with: songsCollection[indexCurrentSong], songs: songsCollection, selectedSong: indexCurrentSong)
    }

}

extension SongsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension SongsVC: DGSongTableViewDelegate {
    func didDeleteSong(at index: Int){
        deleteSong(at: index)
    }
}
