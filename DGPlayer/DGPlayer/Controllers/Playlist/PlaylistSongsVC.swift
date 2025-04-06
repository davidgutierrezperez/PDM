//
//  PlaylistSongsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 24/3/25.
//

import UIKit

/// Controlador que muestra una vista con la lista de
/// canciones de una *playlist* concreta.
class PlaylistSongsVC: SongsVC {
    
    /// *Playlist* asociada al controlador
    private var playlist: Playlist
    
    /// Controles para las distintas opciones de reproducción de la *playlist*
    private var infoPlaylist: DGInfoPlaylist
    
    /// Constructor por defecto de *PlaylistSongsVC*. Establece la playlist a mostrar y
    /// sus canciones.
    /// - Parameters:
    ///   - playlist: *playlist* seleccionada.
    ///   - songs: canciones de la *playlist* seleccionada.
    init(playlist: Playlist){
        
        self.playlist = playlist
        infoPlaylist = DGInfoPlaylist(image: playlist.image, title: playlist.name)
        let songs = FileManagerHelper.loadSongsOfPlaylistFromCoreData(name: playlist.name)
        super.init(songs: songs)
        
        self.navigationItem.title = title
        
        configureButtons()
        configureTableView()
    }
    
    /// Inicializador requerido para cargar la vista desde un archivo storyboard o nib.
    ///
    /// Este inicializador es necesario cuando se utiliza Interface Builder para crear
    /// instancias del controlador. En este caso particular, como el controlador se
    /// configura completamente de forma programática, el uso de storyboards no está soportado,
    /// por lo que se lanza un `fatalError` si se intenta usar.
    ///
    /// - Parameter coder: Objeto utilizado para decodificar la vista desde un archivo nib o storyboard.
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Eventos a ocurrir cuando se carga la vista por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [addButton]

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        
        view.backgroundColor = .systemBackground
        
        configureButtons()
        setupHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (playlist.songs != tableView.songs){
            let songs = FileManagerHelper.loadSongsOfPlaylistFromCoreData(name: playlist.name)
            setSongs(songs: songs)
        }
    }
    
    /// Configura los botones de la vista y establece los botones asociados.
    private func configureButtons(){
        addTargetToBarButton(boton: addButton, target: self, action: #selector(addSongToPlaylist))
        
        infoPlaylist.playFirstSongCollection.addTarget(self, action: #selector(playFirstSong), for: .touchUpInside)
    }
    
    /// Muestra el controlador de selección de canciones el cual permite
    /// seleccionar una canción y añadirla a la *playlist*.
    @objc private func addSongToPlaylist(){
        let songVC = SongSelectorVC(playlistTitle: playlist.name)
        
        songVC.onSongSelected = { [weak self] newSong in
            guard let self = self else { return }
            self.tableView.addSong(song: newSong)
        }
        
        let nv = UINavigationController(rootViewController: songVC)
        present(nv, animated: true)
    }
    
    
    /// Reproduce la primera canción de la *playlist*.
    @objc private func playFirstSong(){
        print(playlist.songs.count)
        SongPlayerVC.present(from: self, with: tableView.songs[0], songs: tableView.songs, selectedSong: 0)
    }
    
    /// Elimina una canción de una *playlist*.
    /// - Parameter index: indice de la canción a eliminar en la tabla de canciones.
    override func deleteSong(at index: Int) {
        let song = tableView.songs[index] as Song
        
        FileManagerHelper.deleteSongOfPlaylistFromCoreData(playlistTitle: playlist.name, songTitle: song.title!)
        tableView.songs.remove(at: index)
        tableView.tableView.reloadData()
    }
    
    /// Establece el *header* con la información de la playlist.
    private func setupHeader() {
        let infoHeader = infoPlaylist
        tableView.setHeaderView(infoHeader)
    }


}

