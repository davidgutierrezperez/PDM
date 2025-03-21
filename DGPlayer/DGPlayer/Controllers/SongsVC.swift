//
//  SongsViewController.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit

class SongsVC: UIViewController {
    
    var tableView: DGTableView!
    let scrollView = UIScrollView()
    var addButton = UIBarButtonItem()
    var enableSearchButton = UIBarButtonItem()
    var isSearchEnable: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = DGTableView(songs: [])
        tableView.delegate = self
        tableView.tableView.delegate = tableView
        
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.searchController = configureSearchController()
        
        addButton = configureAddButton()
        enableSearchButton = configureSearchButton()
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
    
    private func configureAddButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.tintColor = .systemRed
        
        return addButton
    }
    
    private func configureSearchButton() -> UIBarButtonItem {
        let enableSearchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        enableSearchButton.tintColor = .systemRed
        
        return enableSearchButton
    }
    
    func addTargetToButton(boton: UIBarButtonItem, target: AnyObject?, action: Selector) {
        boton.target = target
        boton.action = action
    }
    

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
        print(tableView.songs.count)
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
        
        let songVC = SongPlayerVC(indexSelectedSong: indexCurrentSong, songs: songsCollection)
        songVC.navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.pushViewController(songVC, animated: true)
    }

}

extension SongsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension SongsVC: DGTableViewDelegate {
    func didDeleteSong(at index: Int){
        print("SongsVC: didDeleteSong 1")
        deleteSong(at: index)
        print("SongsVC: didDeleteSong 2")
    }
}
