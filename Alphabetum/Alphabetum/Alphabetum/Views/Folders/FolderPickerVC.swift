//
//  FolderPickerVC.swift
//  Alphabetum
//
//  Created by David Gutierrez on 30/4/25.
//

import UIKit

/// Clase que gestiona la selección de una carpeta
/// por parte de una nota.
class FolderPickerVC: FolderListVC {
    
    /// Objeto que gestiona la información relacionada con una nota.
    private let noteViewModel: NoteViewModel
    
    /// Identificador de la nota que selecciona una carpeta.
    private let noteID: UUID
    
    /// Variable que indica cuando una nota ha selecciona una carpeta y
    /// almacena su identificador.
    var onMoved: ((UUID) -> Void)?
    
    /// Constructor por defecto. Inicializa la instancia con una nota
    /// y su información.
    /// - Parameter note: nota que selecciona una carpeta.
    init(note: Note){
        noteID = note.id
        noteViewModel = NoteViewModel(note: note)
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.tableView.delegate = self
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Eventos a ocurrir cuandoi la vista se carga por primera vez.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nil
    }

    
}

extension FolderPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderID = viewModel.folder(at: indexPath.row).id
        
        noteViewModel.addToFolder(folderID: folderID)
        
        onMoved?(folderID)
        dismiss(animated: true)
    }
}
