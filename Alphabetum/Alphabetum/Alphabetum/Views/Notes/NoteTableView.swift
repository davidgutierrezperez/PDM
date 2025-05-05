//
//  NoteTableView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import UIKit

class NoteTableView: UITableViewController {
    
    private let viewModel = NoteListViewModel.shared
    
    weak var noteCellDelegate: NoteCellDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseIdentifier)

        viewModel.fetchNotesOfFolder(id: viewModel.folderID)
    }
    
    // TODO: Estoy hay que mejorarlo
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchNotesOfFolder(id: viewModel.folderID)
        tableView.reloadData()
    }
    
    func fetchAndReload(){
        viewModel.fetchNotesOfFolder(id: viewModel.folderID)
        tableView.reloadData()
    }

    func reloadData(){
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfNotes()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseIdentifier, for: indexPath) as! NoteCell

        let note = viewModel.note(at: indexPath.row)
        cell.configure(title: note.title)
        cell.delegate = noteCellDelegate
        
        let isSelecting = viewModel.isSelecting
        let isNoteSelected = viewModel.isSelected(id: note.id)
        cell.updateSelectionUI(isVisible: isSelecting, isSelected: isNoteSelected)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteID = viewModel.note(at: indexPath.row).id
        
        if viewModel.isSelecting {
            viewModel.toggleSelection(for: noteID)
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            let noteVC = NoteVC(id: noteID)
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteID = viewModel.note(at: indexPath.row).id
            
            viewModel.delete(id: noteID)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

        // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

}
