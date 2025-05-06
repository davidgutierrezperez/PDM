//
//  NoteTableView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import UIKit

/// Clase que representa
class NoteTableView: UITableViewController {
    
    /// Objeto que gestiona la información de la tabla de notas.
    private let viewModel = NoteListViewModel.shared
    
    /// Variable que indica que se ha seleccionado una celda.
    var onSelectionChanged: (() -> Void)?
    
    /// Variable que indica que se ha borrado una celda.
    var onDeletion: (() -> Void)?
    
    /// Objeto que permite gestionar los eventos de una celda
    /// desde otras vistas
    weak var noteCellDelegate: NoteCellDelegate?

    /// Eventos a ocurrir cuando la vista se carga por primera vez. Se cargan las notas
    ///  de la carpeta y se configuran las celdas.
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseIdentifier)

        viewModel.fetchNotesOfFolder(id: viewModel.folderID)
    }
    
    /// Eventos a ocurrir cuando la vista carga nuevamente. Si hay cambios en
    /// el modelo de datos, actualiza la tabla.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchNotesOfFolder(id: viewModel.folderID)
        tableView.reloadData()
    }
    
    /// Carga las notas de la carpeta en el modelo de datos y actualiza la tabla.
    func fetchAndReload(){
        viewModel.fetchNotesOfFolder(id: viewModel.folderID)
        tableView.reloadData()
    }
    
    /// Actualiza la información de la tabla
    func reloadData(){
        tableView.reloadData()
    }

    /// Indica el número de secciones de la tabla.
    /// - Parameter tableView: tabla que contiene la lista de notas.
    /// - Returns: entero con el número de secciones de la tabla.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /// Indica el número de filas de la tabla, es decir, el número de notas que se muestran en la lista.
    /// - Parameters:
    ///   - tableView: tabla o lista de notas.
    ///   - section: númeor de filas en la sección actual de la tabla.
    /// - Returns: entero con el número de notas en la tabla.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfNotes()
    }

    /// Configura cada una de las celdas de la tabla.
    /// - Parameters:
    ///   - tableView: tabla o lista de notas.
    ///   - indexPath: array con el número de índices de las celdas.
    /// - Returns: celdas de la tabla ya configurada.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseIdentifier, for: indexPath) as! NoteCell

        let note = viewModel.note(at: indexPath.row)
        cell.configure(title: note.title, lastEdited: note.lastModifiedSince)
        cell.delegate = noteCellDelegate
        
        let isSelecting = viewModel.isSelecting
        let isNoteSelected = viewModel.isSelected(id: note.id)
        cell.updateSelectionUI(isVisible: isSelecting, isSelected: isNoteSelected)
        
        return cell
    }
    
    /// Configura los eventos a ocurrir cuando se selecciona una celda.
    /// - Parameters:
    ///   - tableView: tabla o lista de notas.
    ///   - indexPath: array con el número de índices de las celdas.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteID = viewModel.note(at: indexPath.row).id
        
        if viewModel.isSelecting {
            viewModel.toggleSelection(for: noteID)
            tableView.reloadRows(at: [indexPath], with: .none)
            onSelectionChanged?()
        } else {
            let noteVC = NoteVC(id: noteID)
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
    
    /// Configura la edición de las celdas de la tabla.
    /// - Parameters:
    ///   - tableView: tabla o lista de notas
    ///   - editingStyle: estilo de edición de la tabla.
    ///   - indexPath: array de índices de las celdas de la tabla.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteID = viewModel.note(at: indexPath.row).id
            
            viewModel.delete(id: noteID)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            onDeletion?()
        } else if editingStyle == .insert {
            
        }
    }

        // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

}
