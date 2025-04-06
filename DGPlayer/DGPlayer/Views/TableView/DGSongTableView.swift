//
//  DGTableView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 12/3/25.
//

import UIKit

/// Identifiicador a utilizar por las celdas de *DGSongTableView*.
private let reuseIdentifier = "Cell"

/// Protocolo que permite usar instancias de *DGSongTableView* desde
/// vistas padre.
protocol DGSongTableViewDelegate: AnyObject {
    func didDeleteSong(at index: Int)
}

/// Controlador asociado a una tabla que contiene una lista de canciones.
class DGSongTableView: UITableViewController {
    
    /// Lista de canciones de la tabla.
    var songs: [Song] = []
    
    /// Lista de canciones de la tabla cuando se lleva a cabo una búsqueda.
    var filteredSongs: [Song] = []
    
    /// Índica si se está llevando a cabo una búsqueda.
    var isFiltering = false
    
    /// Objecto que permite operar sobre la tabla desde una vista padre.
    weak var delegate: DGSongTableViewDelegate?
    
    /// Constructor por defecto del controlador. Establece las canciones a
    /// mostrar por la tabla.
    /// - Parameter songs: canciones a mostrar por la tabla.
    init(songs: [Song]) {
        self.songs = songs
        super.init(style: .plain)
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
    
    /// Eventos a ocurrir cuando se carga la vista por primera vez. Configura la
    /// tabla y la altura de sus celdas.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DGCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
    }
    
    /// Establece las canciones de a motrar por la tabla.
    /// - Parameter songs: canciones de a motrar por la tabla.
    func setSongs(songs: [Song]) {
        self.songs = songs
        isFiltering = false
        tableView.reloadData()
    }
    
    /// Añade una canción a la tabla.
    /// - Parameter song: canción a añadir a una tabla.
    func addSong(song: Song) {
        self.songs.append(song)
        tableView.reloadData()
    }
    
    /// Establece las canciones a mostrar por la tabla cuando se realiza una búsqueda.
    /// - Parameter songs: canciones a mostrar por la tabla cuando se realiza una búsqueda.
    func setFilteredSong(songs: [Song]){
        self.filteredSongs = songs
        isFiltering = true
        tableView.reloadData()
    }
    
    
    /// Añade una canción a la tabla cuando se realiza una búsqueda.
    /// - Parameter song: canción a añadir a la tabla cuando se realiza una búsqueda.
    func addFilteredSong(song: Song){
        self.filteredSongs.append(song)
        tableView.reloadData()
    }
    
    /// Indica el número de secciones de la tabla.
    /// - Parameter tableView: tabla asociada al controlador.
    /// - Returns: devuelve el número de secciones de la tabla.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Indica el número de filas que tiene la tabla en función de si se está realizando una búsqueda o no.
    /// - Parameters:
    ///   - tableView: tabla asociada a la vista.
    ///   - section: sección de la vista sobre la que se calcula el número de filas.
    /// - Returns: devuelve el número de filas en función de si se está realizando una búsqueda o no.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredSongs.count : songs.count
    }

    /// Configura las celdas de la tabla y su contenido.
    /// - Parameters:
    ///   - tableView: tabla asociada a la vista.
    ///   - indexPath: índice de las filas de la tabla.
    /// - Returns: devuelve cada una de las celdas de la tabla ya configuradas.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DGCell
        let song = isFiltering ? filteredSongs[indexPath.row] : songs[indexPath.row]
        cell.configure(cellTitle: song.title!, cellImage: song.image)
    
        return cell
    }
    
    
    /// Establece el alto de las celdas de la tabla.
    /// - Parameters:
    ///   - tableView: tabla de la vista.
    ///   - section: secciones de la vista.
    /// - Returns: devuelve el valor asociado a la altura de las celdas.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    /// Permite la edición de una tabla y la eliminación de celdas.
    /// - Parameters:
    ///   - tableView: tabla de la vista.
    ///   - editingStyle: estilo de edición.
    ///   - indexPath: índice de la celda seleccionada en la tabla.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.didDeleteSong(at: indexPath.row)
        }
    }
    
    /// Establece una vista como *header* de la tabla.
    /// - Parameter header: vista a establecer como *header* de la tabla de canciones.
    func setHeaderView(_ header: UIView) {
        header.setNeedsLayout()
        header.layoutIfNeeded()

        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame

        tableView.tableHeaderView = header
    }
    
    
}
