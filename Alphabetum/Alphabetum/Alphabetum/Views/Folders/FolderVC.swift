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
        let noteViewModel = NoteViewModel(note: newNote, folderID: folderID)
        
        navigationController?.pushViewController(NoteVC(id: newNote.id), animated: true)
    }
    

}

extension FolderVC: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        viewModel.filterNote(with: searchText ?? "")
        tableView.reloadData()
    }
    
    
}
