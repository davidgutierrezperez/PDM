//
//  FolderListVC.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

class FolderListVC: UIViewController {
    
    let viewModel = FolderListViewModel.shared
    let tableView = FolderTableView()
    
    private let createFolderButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Folders"
        
        tableView.folderCellDelegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = createSearchController(placeholder: "Search a folder", searchResultsUpdater: self, delegate: self)
        navigationItem.searchController?.searchBar.isHidden = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addRightBarButton(image: UIImage(systemName: "folder.badge.plus")!, selector: #selector(openCreateFolderVC))
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (viewModel.hasChanged){
            viewModel.fetchFolders()
            tableView.reloadData()
            viewModel.hasChanged = false
        }
    }
    
    @objc private func openCreateFolderVC(){
        let createFolderVC = CreateEntityVC(title: "New Folder", style: .modal)
        
        createFolderVC.onCreated = { [weak self] folderTitle in
            self?.viewModel.createFolder(title: folderTitle)
            self?.tableView.onCreatedNewFolder()
            self?.viewModel.hasChanged = true
        }
        
        let navVC = UINavigationController(rootViewController: createFolderVC)
        present(navVC, animated: true)
    }
    
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
    
    private func deleteFolderByMenu(id: UUID, onDelete: @escaping () -> Void){
        viewModel.delete(id: id)
        onDelete()
    }
    
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

extension FolderListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterFolders(with: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
}

extension FolderListVC: FolderCellDelegate {
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
