//
//  FavoritesVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit


/// Controlador que reprsenta la vista de canciones favoritas. Controla
/// los eventos de añadido y eliminación de canciones del apartado de
/// favoritos.
class FavoritesVC: SongsVC {
    
    /// Canciones catalogadas como favoritas
    var songs: [Song] = FavoritesManager.shared.songs
    
    
    /// Constructor por defecto de la clase FavoritesVC. Inicializa todos
    /// los valores de SongsVC y añade a la tabla de canciones todas
    /// aquellas catalogadas como favoritas.
    override init(){
        super.init()
        
        tableView.setSongs(songs: songs)
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
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Eventos a ocurrir cuando carga la vista por primera vez
    override func viewDidLoad() {
        super.viewDidLoad()

        configureButtons()
        configureTableView()
    }
    
    
    /// Eventos a ocurrir cuando la vista se carga nuevamente.
    /// - Parameter animated: indica si la transición a la vista es animada.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FavoritesManager.shared.reloadData()
        songs = FavoritesManager.shared.songs
        
        if (tableView.songs.count != songs.count){
            tableView.setSongs(songs: songs)
            tableView.tableView.reloadData()
        }
    }
    
    /// Elimina una canción de la sección de favoritos y actualiza la tabla de canciones.
    /// - Parameter index: indice de la canción a eliminar en la tabla de canciones.
    override func deleteSong(at index: Int){
        let song = tableView.songs[index]
        
        tableView.songs.remove(at: index)
        tableView.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        FavoritesManager.shared.deleteSong(song: song)
        
        FileManagerHelper.addSongToFavourites(title: song.title!)
    }
    
    /// Configura los botones que se muestran en la vista (a excepción de los incluidos en TabBar).
    private func configureButtons(){
        navigationItem.rightBarButtonItem = addButton
        
        addTargetToBarButton(boton: addButton, target: self, action: #selector(addSongToFavorites))
    }
    
    
    /// Añade una canción a favoritos. Esta función es llamada cuando se pulsa el botón
    /// **addButton**.
    @objc private func addSongToFavorites(){
        let songSelectorVC = SongSelectorVC()
        
        songSelectorVC.onSongSelected = { [weak self] newSong in
            guard let self = self else { return }
            tableView.addSong(song: newSong)
        }
        
        let nv = UINavigationController(rootViewController: songSelectorVC)
        present(nv, animated: true)
    }
    

}
