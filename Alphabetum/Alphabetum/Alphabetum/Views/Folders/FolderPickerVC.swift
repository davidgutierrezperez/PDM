//
//  FolderPickerVC.swift
//  Alphabetum
//
//  Created by David Gutierrez on 30/4/25.
//

import UIKit

class FolderPickerVC: FolderListVC {
    
    private let noteViewModel:NoteViewModel
    private let noteID: UUID
    
    init(note: Note){
        noteID = note.id
        noteViewModel = NoteViewModel(note: note)
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.tableView.delegate = self
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nil
    }

    
}

extension FolderPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderID = viewModel.folder(at: indexPath.row).id
        
        noteViewModel.addToFolder(folderID: folderID)
        dismiss(animated: true)
    }
}
