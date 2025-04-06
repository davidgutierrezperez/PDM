//
//  SongSelectorVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

/// Enumerado que permite la selección de
/// la acción a realizar cuando se selecciona una canción.
enum ADD_ACTION {
    case ADD_TO_FAVORITES
    case ADD_TO_PLAYIST
}

/// Controlador que maneja la selección de canciones.
class SongSelectorVC: SongsVC {
    
    /// Botón que permite cancelar la selección de canciones.
    private let cancelButton = UIBarButtonItem()
    
    /// Título de la *playlist* a incluir la canción.
    private let playlistTitle: String
    
    /// Acción por defecto en la selección de canciones.
    private let addAction: ADD_ACTION
    
    /// Clousure que permite acceder a la canción seleccionada
    /// desde otra vista.
    var onSongSelected: ((Song) -> Void)?
    
    /// Constructor utilizado cuando la selección de canciones tiene
    /// como objetivo añadir una canción a una *playlist*.
    /// - Parameter playlistTitle: título de la *playlist* a la que se
    /// añadirá la canción seleccionada.
    init(playlistTitle: String){
        self.playlistTitle = playlistTitle
        addAction = ADD_ACTION.ADD_TO_PLAYIST
        
        super.init()
        
        let songsToSelect = FileManagerHelper.loadSongsFromCoreData()
        tableView = DGSongTableView(songs: songsToSelect)
        tableView.delegate = self
    }
    
    /// Constructor utilizado cuando el objetivo de la selección de canciones
    /// es añadir una canción a favoritos.
    override init(){
        playlistTitle = ""
        addAction = ADD_ACTION.ADD_TO_FAVORITES
        
        super.init()
        
        let songsToSelect = FileManagerHelper.loadSongsFromCoreData()
        tableView = DGSongTableView(songs: songsToSelect)
        tableView.delegate = self
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
    
    /// Eventos a ocurrir cuando la vista carga por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        configureButtons()
        
        configureTableView()
    }
    
    /// Configura los botones de la vista.
    private func configureButtons(){
        cancelButton.title = "Cancel"
        cancelButton.tintColor = .systemRed
        
        navigationItem.leftBarButtonItem = cancelButton
        
        addTargetToBarButton(boton: cancelButton, target: self, action: #selector(dismissVC))
    }
    
    /// Oculta la vista asociada al controlador.
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    /// Realiza una acción asociada a la selección de una canción en la tabla de canciones en función
    /// de la acción especificada.
    /// - Parameters:
    ///   - tableView: tabla de canciones.
    ///   - indexPath: índice de la canción seleccionada en la tabla de canciones.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = (!self.tableView.isFiltering) ?
                    self.tableView.songs[indexPath.row] :
                    self.tableView.filteredSongs[indexPath.row]
        
        if (addAction == ADD_ACTION.ADD_TO_PLAYIST){
            FileManagerHelper.addSongToPlaylist(playlistTitle: playlistTitle, song: song)
        } else {
            FileManagerHelper.addSongToFavourites(title: song.title!)
        }
        
        onSongSelected?(song)
        
        navigationItem.searchController?.isActive = false
        dismiss(animated: true)
    }
    
    
}
