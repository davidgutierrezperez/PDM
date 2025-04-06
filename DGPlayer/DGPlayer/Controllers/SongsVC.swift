//
//  SongsViewController.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit

/// Controlador que maneja vistas que contienen listas de canciones.
class SongsVC: MainViewsCommonVC {
    
    /// Tabla que contiene las canciones mostradas en la vista.
    var tableView: DGSongTableView!
    
    /// Constructor para vistas que inicialmente no tienen ninguna canción.
    override init(){
        tableView = DGSongTableView(songs: [])
        
        super.init()
    }
    
    /// Constructor por defecto. Establece las canciones que se mostrarán en la tabla
    /// de canciones.
    /// - Parameter songs: canciones a mostrar en la tabla de canciones.
    init(songs: [Song]){
        tableView = DGSongTableView(songs: songs)
        
        super.init()
    }
    
    /// Inicializador requerido para cargar la vista desde un archivo storyboard o nib.
    ///
    /// Este inicializador es necesario cuando se utiliza Interface Builder para crear
    /// instancias del controlador. En este caso particular, como el controlador se
    /// configura completamente de forma programática, el uso de storyboards no está soportado,
    /// por lo que se lanza un `fatalError` si se intenta usar.
    ///
    /// - Parameter coder: Objeto utilizado para decodificar la vista desde un archivo nib o storyboard.
    required init?(coder: NSCoder) {
        super.init()
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Eventos a ocurrir cuando la vista carga por primera vez.
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
    }
    
    /// Eventos a ocurrir cuando la vista se carga nuevamente.
    /// - Parameter animated: índica si se debe animar la aparición de la vista.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    /// Configura el controlador de búsqueda.
    func configureSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a song"
        
        return searchController
    }
    
    /// Configura el layout y manejo de la tabla de canciones.
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
    
    /// Establece el array de canciones a mostrar en la tabla de canciones.
    /// - Parameter songs: array de canciones a mostrar.
    func setSongs(songs: [Song]){
        tableView.setSongs(songs: songs)
        tableView.tableView.reloadData()
    }
    
    /// Recarga los datos de la tabla de canciones.
    func reloadTableView(){
        tableView.tableView.reloadData()
    }
    
    /// Elimina una canción de la vista.
    /// - Parameter index: índice de la canción a eliminar de la tabla de canciones.
    func deleteSong(at index: Int){}
    
}

extension SongsVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    /// Actualiza los elementos de la tabla de canciones en función de la búsqueda realizada.
    /// - Parameter searchController: controlador de búsqueda utilizado.
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            reloadTableView()
            return
        }
        
        let filteredSongs = tableView.songs.filter { $0.title?.lowercased().contains(filter) ?? false }
        tableView.setFilteredSong(songs: filteredSongs)
    }
    
    /// Reestablece los elementos de la tabla de cancioones cuando la búsqueda se cancela.
    /// - Parameter searchBar: barra de búsqueda utilizada.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setSongs(songs: tableView.songs)
        reloadTableView()
    }
}

extension SongsVC: UITableViewDelegate {
    
    /// Presenta el reproductor asociada a la canción seleccionada en la tabla de
    /// canciones.
    /// - Parameters:
    ///   - tableView: tabla de canciones de la vista.
    ///   - indexPath: índice de la canción seleccionada.
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
    /// Establece el alto de una celda de la tabla de canciones.
    /// - Parameters:
    ///   - collectionView: colección de elementos mostrada en la vista.
    ///   - collectionViewLayout: layout de la colección de elementos.
    ///   - indexPath: índice de los elementos mostrados en la colección.
    /// - Returns: devuelve el tamaño de cada una de las celdas de la colección.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension SongsVC: DGSongTableViewDelegate {
    /// Elimina una canción de la tabla de canciones.
    /// - Parameter index: índice de la canción a eliminar de la tabla de canciones.
    func didDeleteSong(at index: Int){
        deleteSong(at: index)
    }
}
