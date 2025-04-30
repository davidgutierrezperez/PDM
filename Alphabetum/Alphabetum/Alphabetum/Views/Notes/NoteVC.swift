//
//  NoteViewController.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

class NoteVC: UIViewController {
    
    private let noteRepository = NoteRepository()
    private let viewModel: NoteViewModel
    
    
    init() {
        self.viewModel = NoteViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(id: UUID){
        if let existingNote = noteRepository.fetchById(id: id) {
            self.viewModel = NoteViewModel(note: existingNote)
        } else {
            self.viewModel = NoteViewModel()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.getNote().title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [createBarButton(image: UIImage(systemName: "folder.badge.plus") ?? UIImage(), selector: #selector(selectFolder)),
                                              createBarButton(image: UIImage(systemName: "checkmark") ?? UIImage(), selector: #selector(saveNote))]
    }
    
    @objc private func saveNote(){
        let note = viewModel.getNote()
        
        noteRepository.save(note: note)
    }
    
    @objc private func selectFolder(){
        let folderPickerVC = FolderPickerVC(note: viewModel.getNote())
        let navVC = UINavigationController(rootViewController: folderPickerVC)
        
        present(navVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
