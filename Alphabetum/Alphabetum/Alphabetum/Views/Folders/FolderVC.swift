//
//  FolderViewController.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

class FolderVC: UIViewController, UISearchBarDelegate {
    
    private let viewModel = NoteListViewModel.shared
    private let tableView = NoteTableView()
    
    private let folderID: UUID
    private let folderTitle: String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = folderTitle
        tableView.noteCellDelegate = self
        
        addRightBarButton(image: UIImage(systemName: "plus.circle") ?? UIImage(), selector: #selector(addNoteToFolder))
        
        navigationItem.searchController = createSearchController(searchResultsUpdater: self, delegate: self)
        navigationItem.searchController?.searchBar.isHidden = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupView()
    }
    
    init(folderID: UUID, title: String) {
        self.folderID = folderID
        self.folderTitle = title
        
        viewModel.setFolderID(id: folderID)
        
        if (title == "All"){
            viewModel.fetchAll()
        } else {
            viewModel.fetchNotesOfFolder(id: folderID)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @objc private func addNoteToFolder(){
        let newNote = Note(title: "Sin titulo")
        let _ = NoteViewModel(note: newNote, folderID: folderID)
        
        navigationController?.pushViewController(NoteVC(id: newNote.id), animated: true)
    }
    
    private func openAlertToRenameAction(id: UUID, onRename: @escaping (() -> Void)){
        let alert = makeAlertCancelConfirm(title: "Rename", placeholder: "New title") { newTitle in
            self.viewModel.rename(id: id, newTitle: newTitle)
            onRename()
        }
        present(alert, animated: true)
    }
    
    private func openAlertToDuplicateAction(id: UUID, onDuplicate: @escaping (() -> Void)){
        let alert = makeAlertCancelConfirm(title: "Duplicate a note", placeholder: "Title of the new note", action: { title in
            self.viewModel.duplicate(id: id, title: title)
            onDuplicate()
        })
        
        present(alert, animated: true)
    }
    
    private func openAlertToMoveToAnotherFolder(at index: Int, onMove: @escaping (() -> Void)){
        let folderPickerVC = FolderPickerVC(note: viewModel.note(at: index))
        let navVC = UINavigationController(rootViewController: folderPickerVC)
        
        folderPickerVC.onMoved = {
            onMove()
        }
        
        present(navVC, animated: true)
    }
    
    private func openAlertToDeleteAction(id: UUID){
        viewModel.delete(id: id)
        tableView.fetchAndReload()
    }

}

extension FolderVC: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        viewModel.filterNote(with: searchText ?? "")
        tableView.reloadData()
    }
    
    
}

extension FolderVC: NoteCellDelegate {
    func makePreviewViewController(for cell: NoteCell) -> NoteVC {
        guard let indexPath = tableView.tableView.indexPath(for: cell) else { return NoteVC() }
        
        let note = viewModel.note(at: indexPath.row)
        let noteVC = NoteVC(id: note.id)
        
        noteVC.hideFormattingViewOptions()
        
        return noteVC
    }
    
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
            }
        }
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.openAlertToDeleteAction(id: note.id)
        }
        
        return UIMenu(title: folderTitle, children: [renameAction, duplicateAction, moveToAnotherFolderAction, deleteAction])
    }
}
