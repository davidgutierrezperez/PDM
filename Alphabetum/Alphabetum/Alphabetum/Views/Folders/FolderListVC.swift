//
//  FolderListVC.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

/// Clase que gestiona la vista con la lista de carpetas almacendas
/// en la tabla.
class FolderListVC: UIViewController {
    
    /// Objeto que gestiona la información de la lista de carpetas
    let viewModel = FolderListViewModel.shared
    
    /// Tabla que representa la lista de carpetas
    let tableView = FolderTableView()
    
    /// Botón que permite crear una nueva carpeta.
    private let createFolderButton = UIBarButtonItem()
    
    /// Eventos a ocurrir cuando la vista se carga por primera vez. Se configura la tabla y
    /// la vista.
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Folders"
        
        tableView.folderCellDelegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = createSearchController(placeholder: "Search a folder", searchResultsUpdater: self, delegate: self)
        navigationItem.searchController?.searchBar.isHidden = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        addRightBarButton(image: UIImage(systemName: "folder.badge.plus")!, selector: #selector(openCreateFolderVC))
        setupView()
    }
    
    /// Eventos a ocurrir cuando la vista carga nuevamente. Comprueba si ha habido
    /// cambios y actualiza los datos de la tabla.
    /// - Parameter animated: indica si se debe animar el accedo a la vista.
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if (viewModel.hasChanged){
            viewModel.fetchFolders()
            tableView.reloadData()
            viewModel.hasChanged = false
        }
    }
    
    /// Establece una vista para la creación de una nueva carpeta y
    /// actualiza los datos de la tabla de carpetas.
    @objc private func openCreateFolderVC(){
        let createFolderVC = CreateEntityVC(title: "New Folder", style: .modal)
        
        createFolderVC.onCreated = { [weak self] folderTitle in
            self?.createFolderWithValidation(title: folderTitle)
        }
        
        let navVC = UINavigationController(rootViewController: createFolderVC)
        present(navVC, animated: true)
    }

    private func createFolderWithValidation(title: String) {
        let viewModel = self.viewModel
        
        if viewModel.folderExists(title: title) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let alert = makeAlertCancelConfirm(
                    title: "Folder already exists. Please enter a new name.",
                    placeholder: "New title",
                    action: { newTitle in
                        self.createFolderWithValidation(title: newTitle)
                    }
                )
                self.present(alert, animated: true)
            }
        } else {
            viewModel.createFolder(title: title)
            tableView.onCreatedNewFolder()
            viewModel.hasChanged = true
        }
    }

    /// Crea una alerta que permite renombrar una carpeta.
    /// - Parameters:
    ///   - id: identificador de la carpeta a renombrar.
    ///   - onRenamed: evento a ocurrir cuando se renombre la carpeta.
    private func openAlertToRenameFolder(id: UUID, onRenamed: @escaping () -> Void){
        let alert = UIAlertController(title: "Rename a folder", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = "New folder title"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
            let newTitle = alert.textFields?.first?.text
            self.viewModel.renameFolder(id: id, newTitle: newTitle ?? "")
            onRenamed()
        })
        
        present(alert, animated: true)
    }
    
    /// Elimina una carpeta desde un menu de interación.
    /// - Parameters:
    ///   - id: identificador de la carpeta a eliminar.
    ///   - onDelete: evento a ocurrir cuando se elimina la carpeta.
    private func deleteFolderByMenu(id: UUID, onDelete: @escaping () -> Void){
        viewModel.delete(id: id)
        onDelete()
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
    }

}

/// Extensión que gestiona la actualización de resultados en la barra de búsqueda.
extension FolderListVC: UISearchResultsUpdating, UISearchBarDelegate {
    /// Gestiona la actualización de resultados en la barra de búsqueda y actualiza los
    /// datos en la tabla de carpetas.
    /// - Parameter searchController: barra de búsqueda.
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterFolders(with: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
}

/// Gestiona los eventos relacionados con las celdas de la tabla de carpetas.
extension FolderListVC: FolderCellDelegate {
    
    /// Crea un menu de interación que permite llevar a cabo acciones sobre una celda.
    /// - Parameter cell: celda sobre la que se mostrará el menu de interacción.
    /// - Returns: objeto de tipo UIMenu que representa el menu.
    func folderCellRequestMenu(for cell: FolderCell) -> UIMenu {
        guard let indexPath = tableView.tableView.indexPath(for: cell) else {
            return UIMenu()
        }
        
        let folder = viewModel.folder(at: indexPath.row)
        
        guard folder.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000") else {
            return UIMenu()
        }
        
        let rename = UIAction(title: "Rename") { _ in
            self.openAlertToRenameFolder(id: folder.id) {
                self.tableView.fetchAndReload()
            }
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.deleteFolderByMenu(id: folder.id) {
                self.tableView.fetchAndReload()
            }
        }
        
        return UIMenu(title: folder.title, children: [rename, delete])
    }
    
    
}
