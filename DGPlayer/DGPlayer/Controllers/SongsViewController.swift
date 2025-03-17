//
//  SongsViewController.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit

class SongsViewController: UIViewController {
    
    var collectionView: DGCollectionView!
    var songs: [Song] = []
    var filteredSongs : [Song] = []
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.searchController = configureSearchController()
    }
    
    private func configureSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a song"
        
        return searchController
    }
    
    func configureCollectionView(){
        collectionView.tableView.delegate = self
        collectionView.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setSongs(songs: [Song]){
        collectionView.setSongs(songs: songs)
        collectionView.tableView.reloadData()
    }
    
    
    func reloadCollectionView(){
        collectionView.tableView.reloadData()
    }
    

}

extension SongsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        if (filter.isEmpty){
            setSongs(songs: songs)
        } else {
            filteredSongs = songs.filter { $0.title?.lowercased().contains(filter.lowercased()) ?? false }

            setSongs(songs: filteredSongs)
        }
        reloadCollectionView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setSongs(songs: songs)
        reloadCollectionView()
    }
}

extension SongsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var songsCollection: [Song] = []
        var indexCurrentSong: Int
        
        if let searchText = navigationItem.searchController?.searchBar.text, !searchText.isEmpty {
            songsCollection.append(filteredSongs[indexPath.item])
            indexCurrentSong = 0
        } else {
            songsCollection = songs
            indexCurrentSong = indexPath.item
        }
        
        let songVC = SongVC(indexSelectedSong: indexCurrentSong, songs: songsCollection)
        songVC.navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.pushViewController(songVC, animated: true)
    }
    

}

extension SongsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
