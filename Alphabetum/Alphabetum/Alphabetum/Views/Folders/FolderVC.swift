//
//  FolderViewController.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

/// Clase que gestiona la vista con la información de una carpeta, es decir, muestra
/// la lista de notas almacenadas en una carpeta.
class FolderVC: UIViewController, UISearchBarDelegate {
    
    /// Objeto que gestiona la información de una lita de notas.
    private let viewModel = NoteListViewModel.shared
    
    /// Tabla que gestiona la lista de notas-
    private let tableView = NoteTableView()

    /// Título de la carpeta.
    private let folderTitle: String
    
    /// Botón que permite acceder a la vista para añadir notas a la carpeta.
    private var addToFolderButton = UIBarButtonItem()
    
    /// Botón que permite acceder a la gestión de notas.
    private var editNotesButton = UIBarButtonItem()
    
    /// Eventos a ocurrir cuando se carga la vista por primera vez. Configura el layout y la visualización de la vista.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = folderTitle
        tableView.noteCellDelegate = self
        
        addToFolderButton.configureButton(systemName: "plus.circle", selector: #selector(addNoteToFolder), target: self)
        editNotesButton.configureButton(title: "Edit", selector: #selector(selectAndEditNotes), target: self)
        editNotesButton.isHidden = (viewModel.numberOfNotes() == 0)
        
        navigationItem.searchController = createSearchController(searchResultsUpdater: self, delegate: self)
        navigationItem.searchController?.searchBar.isHidden = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItems = [addToFolderButton, editNotesButton]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupView()
    }
    
    /// Eventos a ocurrir cuando la vista carga nuevamente.
    /// - Parameter animated: indica si la aparición de la vista debe animarse.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.setSelecting(false)
        updateEditButton()
    }
    
    /// Constructor por defecto de la vista. Obtiene los datos de la carpeta y sus notas.
    /// - Parameters:
    ///   - folderID: identificador de la carpeta.
    ///   - title: título de la carpeta.
    init(folderID: UUID, title: String) {
        self.folderTitle = title
        
        viewModel.setFolderID(id: folderID)
        viewModel.fetchNotesOfFolder(id: folderID)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura el layout de la vista.
    private func setupView(){
        addChild(tableView)
        view.addSubview(tableView.view)
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.view.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.didMove(toParent: self)
        
        tableView.onDeletion = { [weak self] in
            self?.updateEditButton()
        }
    }
    
    /// Evento que gestiona la creación de una nueva nota y la añade
    /// a la carpeta actual.
    @objc private func addNoteToFolder(){
        let newNote = Note(title: "Sin titulo")
        let _ = NoteViewModel(note: newNote, folderID: viewModel.folderID)
        
        navigationController?.pushViewController(NoteVC(id: newNote.id), animated: true)
    }
    
    /// Evento que gestiona la selección y edición de notas.
    @objc private func selectAndEditNotes(){
        viewModel.setSelecting(true)
        tableView.reloadData()
        navigationController?.tabBarController?.tabBar.isHidden = true

        addToFolderButton.configureButton(title: "Delete all", selector: #selector(deleteSelectedNotes), target: self)
        tableView.onSelectionChanged = { [weak self] in
            self?.updateDeleteButton()
        }
        
        editNotesButton.configureButton(title: "Cancel", selector: #selector(cancelSelection), target: self)
    }
    
    /// Evento que gestiona la cancelación del modo de selección.
    @objc private func cancelSelection(){
        viewModel.setSelecting(false)
        tableView.reloadData()
        navigationController?.tabBarController?.tabBar.isHidden = false
        addToFolderButton.configureButton(systemName: "plus.circle", selector: #selector(addNoteToFolder), target: self)
        
        editNotesButton.configureButton(title: "Edit", selector: #selector(selectAndEditNotes), target: self)
    }
    
    /// Actualiza el boton de borrado en función de su estado.
    private func updateDeleteButton(){
        guard viewModel.isSelecting else { return }
        
        let count = viewModel.numberOfSelectedNotes()
        let deleteTitle = "Delete (\(count))"
        
        addToFolderButton.configureButton(title: deleteTitle, selector: #selector(deleteSelectedNotes), target: self)
    }
    
    /// Actualiza el botón de edición en función de su estado.
    private func updateEditButton(){
        editNotesButton.isHidden = (viewModel.numberOfNotes() == 0)
    }
    
    /// Gestiona el evento de eliminación de notas seleccionadas.
    @objc private func deleteSelectedNotes(){
        viewModel.deleteSelectedNotes()
        updateEditButton()
        cancelSelection()
    }
    
    /// Establece una alerta que permite gestionar el renombramiento de una nota.
    /// - Parameters:
    ///   - id: identificador de la nota a renombrar.
    ///   - onRename: evento a ocurrir cuando se renombra la nota.
    private func openAlertToRenameAction(id: UUID, onRename: @escaping (() -> Void)){
        let alert = makeAlertCancelConfirm(title: "Rename", placeholder: "New title") { newTitle in
            self.viewModel.rename(id: id, newTitle: newTitle)
            onRename()
        }
        present(alert, animated: true)
    }
    
    /// Establece una alerta que permite gestionar el duplicado de la nota.
    /// - Parameters:
    ///   - id: identificador de la nota a duplicar.
    ///   - onDuplicate: evento a ocurrir cuando se duplique la nota.
    private func openAlertToDuplicateAction(id: UUID, onDuplicate: @escaping (() -> Void)){
        let alert = makeAlertCancelConfirm(title: "Duplicate a note", placeholder: "Title of the new note", action: { title in
            self.viewModel.duplicate(id: id, title: title)
            onDuplicate()
        })
        
        present(alert, animated: true)
    }
    
    /// Establece una alerta que permite gestionar el traslado de una nota a otra carpeta.
    /// - Parameters:
    ///   - index: índice de la carpeta seleccionada en la tabla de carpetas.
    ///   - onMove: evento a ocurrir cuando es traslade la nota.
    private func openAlertToMoveToAnotherFolder(at index: Int, onMove: @escaping (() -> Void)){
        let folderPickerVC = FolderPickerVC(note: viewModel.note(at: index))
        let navVC = UINavigationController(rootViewController: folderPickerVC)
        
        folderPickerVC.onMoved = { _ in
            onMove()
        }
        
        present(navVC, animated: true)
    }
    
    /// Establece una alerta para copiar una nota a otra carpeta.
    /// - Parameter index: índice de la carpeta seleccionada en la tabla de carpetas.
    private func openAlertToCopyToAnotherFolder(at index: Int){
        let folderPickerVC = FolderPickerVC(note: viewModel.note(at: index))
        let navVC = UINavigationController(rootViewController: folderPickerVC)
        
        folderPickerVC.onMoved = { _ in
            let noteID = self.viewModel.note(at: index).id
            let folderID = self.viewModel.folderID
            self.viewModel.copyInOtherFolder(id: noteID, to: folderID)
        }
        
        present(navVC, animated: true)
    }
    
    /// Establece una alerta para eliminar una nota.
    /// - Parameter id: identificador de la nota a eliminar.
    private func openAlertToDeleteAction(id: UUID){
        viewModel.delete(id: id)
        tableView.fetchAndReload()
        updateEditButton()
    }

}

/// Extensión que gestiona la búsqueda y filtrado de notas mediante la barra búsqueda.
extension FolderVC: UISearchControllerDelegate, UISearchResultsUpdating {
    
    /// Gestiona la actualización de resultados mediante la barra búsqueda.
    /// - Parameter searchController: controlador que representa la barra búsqueda.
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        viewModel.filterNote(with: searchText ?? "")
        tableView.reloadData()
    }
    
    
}

/// Extensión que gestiona los eventos de las celdas asociadas a notas.
extension FolderVC: NoteCellDelegate {
    
    /// Crea una previsualización de la vista asociada a una nota.
    /// - Parameter cell: celda asociada a la nota.
    /// - Returns: objeto de tipo NoteVC que representa la vista con información de una nota.
    func makePreviewViewController(for cell: NoteCell) -> NoteVC {
        guard let indexPath = tableView.tableView.indexPath(for: cell) else { return NoteVC() }
        
        let note = viewModel.note(at: indexPath.row)
        let noteVC = NoteVC(id: note.id)
        
        noteVC.hideFormattingViewOptions()
        
        return noteVC
    }
    
    /// Crea un menu con interaciones que gestionan eventos sobre la celda asociada a una nota.
    /// - Parameter cell: celda asociada a una nota.
    /// - Returns: devuelve un objeto UIMenu que representa el menu de interaciones.
    func noteCellRequestMenu(for cell: NoteCell) -> UIMenu {
        guard let indexPath = tableView.tableView.indexPath(for: cell) else { return UIMenu() }
        
        let note = viewModel.note(at: indexPath.row)
        
        let renameAction = UIAction(title: "Rename") { _ in
            self.openAlertToRenameAction(id: note.id){
                self.tableView.fetchAndReload()
            }
        }
        
        let duplicateAction = UIAction(title: "Duplicate") { _ in
            self.openAlertToDuplicateAction(id: note.id){
                self.tableView.fetchAndReload()
            }
        }
        
        let moveToAnotherFolderAction = UIAction(title: "Move to another folder") { _ in
            self.openAlertToMoveToAnotherFolder(at: indexPath.row) { 
                self.tableView.fetchAndReload()
                self.updateEditButton()
            }
        }
        
        let copyToAnotherFolderAction = UIAction(title: "Copy to another folder") { _ in
            self.openAlertToCopyToAnotherFolder(at: indexPath.row)
        }
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.openAlertToDeleteAction(id: note.id)
        }
        
        return UIMenu(title: folderTitle, children: [renameAction, duplicateAction, moveToAnotherFolderAction, copyToAnotherFolderAction, deleteAction])
    }
}
