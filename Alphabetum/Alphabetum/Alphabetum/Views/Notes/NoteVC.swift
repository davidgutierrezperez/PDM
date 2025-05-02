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
    private var titleField = UITextField()
    private var contentView = UITextField()
    
    
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
        
        titleField.text = viewModel.getNote().title
        contentView.text = viewModel.getNote().content.string
        
        title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItems = [createBarButton(image: UIImage(systemName: "folder.badge.plus") ?? UIImage(), selector: #selector(selectFolder))]
        
        configureTextFields()
        setupView()
    }
    
    @objc private func saveNote(){
        viewModel.saveNote()
    }
    
    @objc private func updateTitle(){
        viewModel.updateTitle(titleField.text!)
    }
    
    @objc private func updateContent(){
        let newContent = contentView.attributedText?.mutableCopy() as? NSMutableAttributedString
        viewModel.updateContent(newContent ?? NSMutableAttributedString(""))
    }
    
    @objc private func selectFolder(){
        let folderPickerVC = FolderPickerVC(note: viewModel.getNote())
        let navVC = UINavigationController(rootViewController: folderPickerVC)
        
        present(navVC, animated: true)
    }
    
    private func setupView(){
        view.addSubview(titleField)
        view.addSubview(contentView)
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        // Título (UITextField)
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 40),

            // Contenido (UITextView)
            contentView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureTextFields(){
        titleField.addTarget(self, action: #selector(updateTitle), for: .editingChanged)
        titleField.font = .preferredFont(forTextStyle: .title1)
        titleField.borderStyle = .roundedRect
        
        contentView.addTarget(self, action: #selector(updateContent), for: .editingChanged)
        contentView.borderStyle = .roundedRect
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
