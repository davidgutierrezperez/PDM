//
//  FolderTableView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import UIKit

/// Clase que gestiona las tablas o listas de carpetas.
class FolderTableView: UITableViewController {
    
    /// Objeto que gestiona los datos relacionadas con listas de tablas.
    private let viewModel = FolderListViewModel.shared
    
    /// Objeto que permite gestionar los eventos de las celdas de la tabla
    /// desde otras vistas.
    weak var folderCellDelegate: FolderCellDelegate?
    
    /// Eventos a ocurrir cuando la vista se carga por primera vez. Se registran las celdas
    /// y se obtienen las notas asociadas a la carpeta.
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FolderCell.self, forCellReuseIdentifier: FolderCell.reusableIdentifier)
        
        fetchAndReload()
    }
    
    /// Eventos a ocurrir cuando la vista aparece nuevamente. Comprueba si ha habido
    /// cambios en la información y actualiza el contenido.
    /// - Parameter animated: indica si la aparición de la vista debe ser animada.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (viewModel.hasChanged){
            fetchAndReload()
            viewModel.hasChanged = false
        }
    }
    
    /// Indica al *viewModel* que obtenga las notas asociadas a
    /// una carpeta y actualiza los datos de la tabla.
    func fetchAndReload(){
        viewModel.fetchFolders()
        tableView.reloadData()
    }
    
    /// Actualiza los datos de la tabla tras crear una nueva nota.
    func onCreatedNewFolder(){
        fetchAndReload()
    }
    
    /// Recarga los datos de la tabla.
    func reloadData(){
        tableView.reloadData()
    }

    
    /// Indica el número de secciones de la tabla.
    /// - Parameter tableView: tabla que contiene la lista de carpetas.
    /// - Returns: entero con el número de secciones de la tabla.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    /// Indica el número de filas de la tabla, es decir, el número de carpetas que se muestran en la lista.
    /// - Parameters:
    ///   - tableView: tabla o lista de carpetas.
    ///   - section: númeor de filas en la sección actual de la tabla.
    /// - Returns: entero con el número de carpetas en la tabla.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfFolders()
    }

    
    /// Configura cada una de las celdas de la tabla.
    /// - Parameters:
    ///   - tableView: tabla o lista de carpetas.
    ///   - indexPath: array con el número de índices de las celdas.
    /// - Returns: celdas de la tabla ya configurada.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.reusableIdentifier, for: indexPath) as? FolderCell

        let folder = viewModel.folder(at: indexPath.row)
        
        let numberOfNotes = (folder.id.uuidString == "00000000-0000-0000-0000-000000000000") ? 0 : folder.notes.count
        cell?.configure(title: folder.title, numberOfNotes: numberOfNotes)
        cell?.delegate = folderCellDelegate

        return cell ?? UITableViewCell()
    }
    
    /// Configura los eventos a ocurrir cuando se selecciona una celda.
    /// - Parameters:
    ///   - tableView: tabla o lista de carpetas.
    ///   - indexPath: array con el número de índices de las celdas.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = viewModel.folder(at: indexPath.row)
        let folderVC = FolderVC(folderID: folder.id, title: folder.title)
        
        navigationController?.pushViewController(folderVC, animated: true)
    }
    
    /// Configura la edición de las celdas de la tabla.
    /// - Parameters:
    ///   - tableView: tabla o lista de carpetas
    ///   - editingStyle: estilo de edición de la tabla.
    ///   - indexPath: array de índices de las celdas de la tabla.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folder = viewModel.folder(at: indexPath.row)

            viewModel.delete(id: folder.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /// Indica si se puede editar una determina celda
    /// - Parameters:
    ///   - tableView: tabla o lista de carpetas.
    ///   - indexPath: array de índices de las celdas de la tabla.
    /// - Returns: un booleano con valor **True** si se puede editar una celda y **False** en caso contrario.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let folder = viewModel.folder(at: indexPath.row)
        return folder.id.uuidString != "00000000-0000-0000-0000-000000000000"
    }

}
