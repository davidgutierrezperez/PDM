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
    private let formattingViewModel: TextFormattingViewModel
    
    private var titleField = UITextField()
    private var contentView = UITextView()
    
    private var selectFolderButton = UIBarButtonItem()
    private var disableKeyboardButton = UIBarButtonItem()
    
    private let textFormattingOptionsView = TextFormattingOptionsView()
    
    
    init() {
        self.viewModel = NoteViewModel()
        self.formattingViewModel = TextFormattingViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(id: UUID){
        if let existingNote = noteRepository.fetchById(id: id) {
            self.viewModel = NoteViewModel(note: existingNote)
        } else {
            self.viewModel = NoteViewModel()
        }
        
        self.formattingViewModel = TextFormattingViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.text = viewModel.getNote().title
        contentView.attributedText = viewModel.getNote().content
        
        title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configureButtons()
        configureTextFormattingOptionsView()
        navigationItem.rightBarButtonItems = [selectFolderButton, disableKeyboardButton]
        
        contentView.inputAccessoryView = textFormattingOptionsView
        contentView.reloadInputViews()
        
        configureTextFields()
        

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.becomeFirstResponder()
        contentView.reloadInputViews()
    }
    
    private func configureTextFormattingOptionsView(){
        textFormattingOptionsView.onBoldTap = { [weak self] in
            self?.toggleBold()
        }
    }
    
    private func toggleBold() {
        formattingViewModel.toggleBold()

        let defaultFontSize: CGFloat = 16

        let currentFont = (contentView.typingAttributes[.font] as? UIFont)
            ?? UIFont.systemFont(ofSize: defaultFontSize)

        let newFont: UIFont = formattingViewModel.isBold
            ? UIFont.boldSystemFont(ofSize: currentFont.pointSize)
            : UIFont.systemFont(ofSize: currentFont.pointSize)

        contentView.typingAttributes[.font] = newFont
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
                                                              
    @objc private func disableKeyboard(){
        contentView.endEditing(true)
            
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
        
        contentView.delegate = self
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        
    }

    private func configureButtons(){
        selectFolderButton = createBarButton(image: UIImage(systemName: "folder.badge.plus") ?? UIImage(), selector: #selector(selectFolder))
        disableKeyboardButton = createBarButton(image: UIImage(systemName: "checkmark") ?? UIImage(), selector: #selector(disableKeyboard))
    }
}

extension NoteVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateContent(textView.attributedText.mutableCopy() as! NSMutableAttributedString)
    }
    
}
