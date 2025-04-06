//
//  HomeVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit
import AVFoundation

/// Controlador que representa la vista principal de la aplicación. Muestra todas
/// las canciones almacenadas en la aplicación y controla los eventos de añadido y
/// eliminación de canciones.
class HomeVC: SongsVC {
    
    /// Constructor por defecto de Home. Inicializa todos los valores de
    /// SongsVC y carga en pantalla todas las canciones almacenadas.
    override init() {
        super.init()
        
        let songs = FileManagerHelper.loadSongsFromCoreData()
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
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /// Eventos a ocurrir cuando la vista carga por primera vez
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()
        configureTableView()
    }
    
    /// Eventos a ocurrir cuando la vista se vuelva a mostrar.
    /// - Parameter animated: indica si hay una animación al mostrar la pantalla de nuevo.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    /// Elimina una canción por completo de la aplicación. También elimina su acceso desde la tabla de canciones
    /// y en caso de eliminar la canción que se esté reproduciendo, se termina su reproducción.
    /// - Parameter index: indice de la canción en la tabla de canciones.
    override func deleteSong(at index: Int){
        let song = tableView.songs[index]
        
        tableView.songs.remove(at: index)
        tableView.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        
        FileManagerHelper.deleteSong(song: song)
        
        if (SongPlayerManager.shared.song?.title == song.title ){
            SongPlayerFooterVC.shared.hide()
            SongPlayerManager.shared.player?.stop()
            SongPlayerManager.shared.isSongPlayerConfigured = false
        }
    }
    
    /// Añade una canción a la tabla/lista de canciones de la vista.
    /// - Parameter song: canción a añadir a la tabla/lista de canciones.
    private func addSongToTableView(song: Song){
        tableView.addSong(song: song)
    }
    
    /// Configura los diferents botones de la vista (no incluye botones del TabBar).
    private func configureButtons(){
        addTargetToBarButton(boton: addButton, target: self, action: #selector(openDocumentPicker))
        
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    /// Permite abrir un controlador para selección de ficheros de audio.
     @objc func openDocumentPicker(){
         let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3, .wav, .audio])
        documentPicker.delegate = self
        
        present(documentPicker, animated: true)
    }
    
}

extension HomeVC: UIDocumentPickerDelegate {
    
    /// Permite escoger un archivo de audio para su posterior reproducción.
    /// - Parameters:
    ///   - controller: controlador que permite la selección de archivos de audio mediante una interfaz.
    ///   - urls: archivos de audio seleccionados.
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        
        if selectedFile.startAccessingSecurityScopedResource() {
            defer { selectedFile.stopAccessingSecurityScopedResource() }
            
            if (FileManagerHelper.handleSelectedAudio(url: selectedFile)){
                let updatedSongs = FileManagerHelper.loadSongsFromCoreData()
                if let newSong = updatedSongs.last {
                    addSongToTableView(song: newSong)
                }
            }
        }
    }
    
}
