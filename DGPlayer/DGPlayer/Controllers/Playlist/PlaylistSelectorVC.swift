//
//  PlaylistSelectorVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 4/4/25.
//

import UIKit

/// Controlador que permite la selección una *playlist*.
class PlaylistSelectorVC: PlaylistVC {
    
    /// Botón para la cancelación de selección de una *playlist*.
    private let cancelButton = UIBarButtonItem()
    
    /// Canción que se añadirá a la *playlist* asociada.
    private let song: Song

    /// Clousure que permite acceder a la *playlist* seleccionada desde una vista padre
    var onSelectedPlaylist: ((Playlist) -> Void)?
    
    
    /// Constructor por defecto de la clase *PlaylistSelectorVC*. Establece la
    /// canción que será añadida a la *playlist* seleccionada.
    /// - Parameter song: canción que será añadida a la *playlist* seleccionada.
    init(song: Song){
        self.song = song
        
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
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Eventos a ocurrir cuando la vista carga por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()

        title = nil
    }
    
    /// Configura los botones de la vista y establece las funciones asocidas.
    private func configureButtons(){
        cancelButton.title = "Cancel"
        cancelButton.tintColor = .systemRed
        
        addTargetToBarButton(boton: cancelButton, target: self, action: #selector(dismissVC))
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    /// Oculta la vista del controlador.
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    /// Añade una canción a la *playlist* seleccionada cuando se pulsa sobre una de las filas de la tabla
    /// que muestra la lista de *playlists*.
    /// - Parameters:
    ///   - tableView: tabla que contiene la lista total de *playlists* creadas.
    ///   - indexPath: índice de la *playlist* seleccionada.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = (!self.tableView.isFiltering) ?
                        self.tableView.playlists[indexPath.row] :
                        self.tableView.filteredPlaylist[indexPath.row]
        
        FileManagerHelper.addSongToPlaylist(playlistTitle: playlist.name, song: song)
        
        onSelectedPlaylist?(playlist)
        dismiss(animated: true)
    }


    

}
