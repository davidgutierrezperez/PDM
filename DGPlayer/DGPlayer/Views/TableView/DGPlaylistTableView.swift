//
//  DGPlaylistTableView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

private let reuseIdentifier = "Cell"

/// Protocolo a utilizar para eliminar una *playlist* desde otra vista.
protocol DGPlaylistTableViewDelegate: AnyObject {
    func deletePlaylist(at index: Int)
}

/// Controlador de la vista con tabla de *playlists*.
class DGPlaylistTableView: UITableViewController {
    
    /// *Playlists* a mostrar en la tabla.
    var playlists: [Playlist] = []
    
    /// *Playlists* a mostrar cuando se realiza una búsqueda.
    var filteredPlaylist: [Playlist] = []
    
    /// Índica si se esta llevando a cabo una búsqueda.
    var isFiltering: Bool = false
    
    /// Objeto que permite operar con el controlador desde otras vistas.
    weak var delegate: DGPlaylistTableViewDelegate?
    
    /// Eventos a ocurrir cuando se carga la vista por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DGCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
    }
    
    /// Constructor por defecto del controlador. Establece las *playlists*
    /// a mostrar en la tabla.
    /// - Parameter playlists: *playlists* a mostrar en la tabla.
    init(playlists: [Playlist]){
        self.playlists = playlists
        
        super.init(nibName: nil, bundle: nil)
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
    
    /// Permite establecer los *playlists* de la tabla.
    /// - Parameter playlists: nuevas *playlists* a mostrar en la tabla.
    func setPlaylist(playlists: [Playlist]){
        self.playlists = playlists
        isFiltering = false
        
        tableView.reloadData()
    }
    
    /// Añade una *playlist* a la tabla.
     /// - Parameter playlist: *playlist* a añadir a la tabla.
    func addPlaylist(playlist: Playlist){
        playlists.append(playlist)
        isFiltering = false
        
        tableView.reloadData()
    }
    
    /// Establece las *playlists* a mostrar cuando se realiza una búsqueda.
    /// - Parameter playlists: *playlists* a mostrar cuando se realiza la búsqueda.
    func setFilteredPlaylists(playlists: [Playlist]){
        self.filteredPlaylist = playlists
        isFiltering = true
        tableView.reloadData()
    }
    
    /// Añade una *playlist* a la lista de *playlists* a mostrar cuando se realiza una búsqueda.
    /// - Parameter playlist: *playlist* a añadir a la lista de *playlists* cuando se realiza una búsqueda.
    func addFilteredSong(playlist: Playlist){
        self.filteredPlaylist.append(playlist)
        tableView.reloadData()
    }

    
    /// Indica el número de secciones de la tabla.
    /// - Parameter tableView: tabla asociada al controlador.
    /// - Returns: devuelve el número de secciones de la tabla.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    /// Indica el número de filas que tiene la tabla en función de si se está realizando una búsqueda o no.
    /// - Parameters:
    ///   - tableView: tabla asociada a la vista.
    ///   - section: sección de la vista sobre la que se calcula el número de filas.
    /// - Returns: devuelve el número de filas en función de si se está realizando una búsqueda o no.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isFiltering ? filteredPlaylist.count : playlists.count
    }

    /// Configura las celdas de la tabla y su contenido.
    /// - Parameters:
    ///   - tableView: tabla asociada a la vista.
    ///   - indexPath: índice de las filas de la tabla.
    /// - Returns: devuelve cada una de las celdas de la tabla ya configuradas.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DGCell
        let playlist = isFiltering ? filteredPlaylist[indexPath.row] : playlists[indexPath.row]
        cell?.configure(cellTitle: playlist.name, cellImage: playlist.image)

        return cell!
    }
    
    /// Permite la edición de una tabla y la eliminación de celdas.
    /// - Parameters:
    ///   - tableView: tabla de la vista.
    ///   - editingStyle: estilo de edición.
    ///   - indexPath: índice de la celda seleccionada en la tabla.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.deletePlaylist(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
