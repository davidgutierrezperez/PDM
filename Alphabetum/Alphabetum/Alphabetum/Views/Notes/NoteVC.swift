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
        textFormattingOptionsView.onFormatTap = { [weak self] format in
            self?.toggleFormating(format)
        }
    }
    
    private func toggleFormating(_ format: TextFormat){
        let defaultFontSize: CGFloat = 16
        let currentFont = (contentView.typingAttributes[.font] as? UIFont) ?? UIFont.systemFont(ofSize: defaultFontSize)
        let defaultFont = (format == .title) ? UIFont.systemFont(ofSize: defaultFontSize) : UIFont.systemFont(ofSize: currentFont.pointSize)
        
        formattingViewModel.toggleTextFomat(format)
        
        let selectedRange = contentView.selectedRange
        let hasSelection = selectedRange.length > 0
        
        switch(format){
        case .bold, .italic, .title, .header, .subtitle:
            let font = fontWith(format, baseFont: defaultFont)
            
            if hasSelection {
                applyAttribute(.font, value: font, to: selectedRange)
            } else {
                contentView.typingAttributes[.font] = font
            }
            break
        case .underline:
            let style = formattingViewModel.isUnderline ? NSUnderlineStyle.single.rawValue : nil
            
            if hasSelection {
                applyAttribute(.underlineStyle, value: style, to: selectedRange)
            } else {
                contentView.typingAttributes[.underlineStyle] = style
            }
            break
        case .strikethrough:
            let style = formattingViewModel.isStrikeThrough ? NSUnderlineStyle.single.rawValue : nil
            
            if hasSelection {
                applyAttribute(.strikethroughStyle, value: style, to: selectedRange)
            } else {
                contentView.typingAttributes[.strikethroughStyle] = style
            }
            break
        case .bulletlist, .dashList:
            insertListAtCurrentLine(format)
            break
        default:
            break
        }
    }
    
    private func fontWith(_ format: TextFormat, baseFont: UIFont) -> UIFont {
        switch format {
        case .bold:
            return formattingViewModel.isBold ? UIFont.boldSystemFont(ofSize: baseFont.pointSize) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .italic:
            return formattingViewModel.isItalic ? UIFont.italicSystemFont(ofSize: baseFont.pointSize) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .title:
            return formattingViewModel.isTitle ? UIFont.preferredFont(forTextStyle: .title1) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .header:
            return formattingViewModel.isHeader ? UIFont.preferredFont(forTextStyle: .headline) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .subtitle:
            return formattingViewModel.isSubtitle ? UIFont.preferredFont(forTextStyle: .title2) : UIFont.systemFont(ofSize: baseFont.pointSize)
        default:
            return baseFont
        }
    }
    
    private func applyAttribute(_ key: NSAttributedString.Key, value: Any?, to range: NSRange){
        let mutableText = NSMutableAttributedString(attributedString: contentView.attributedText)
        
        if let value = value {
            mutableText.addAttribute(key, value: value, range: range)
        } else {
            mutableText.removeAttribute(key, range: range)
        }
        
        contentView.attributedText = mutableText
        contentView.selectedRange = range
    }
    
    private func insertListAtCurrentLine(_ format: TextFormat){
        var bullet: String = ""
        
        switch format {
        case .bulletlist:
            bullet = "• "
            break
        case .dashList:
            bullet = "- "
            break
        default:
            break
        }
        
        let selectedRange = contentView.selectedRange
        guard let fullText = contentView.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        
        let plainText = fullText.string as NSString
        let lineRange = plainText.lineRange(for: selectedRange)
        
        let lineText = plainText.substring(with: lineRange)
        if lineText.contains(bullet) {
            return
        }
        
        let bulletAttr = NSMutableAttributedString(string: bullet)
        fullText.insert(bulletAttr, at: lineRange.location)
        
        contentView.attributedText = fullText
        contentView.selectedRange = NSRange(location: selectedRange.location + bullet.count, length: 0)
    }
    
    private func insertBulletAtCurrentLine(){
        let bullet = "• "
        let selectedRange = contentView.selectedRange
        guard let fullText = contentView.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        
        let plainText = fullText.string as NSString
        let lineRange = plainText.lineRange(for: selectedRange)
        
        let lineText = plainText.substring(with: lineRange)
        if lineText.contains(bullet) {
            return
        }
        
        let bulletAttr = NSMutableAttributedString(string: bullet)
        fullText.insert(bulletAttr, at: lineRange.location)
        
        contentView.attributedText = fullText
        contentView.selectedRange = NSRange(location: selectedRange.location + bullet.count, length: 0)
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let isList = formattingViewModel.isBulletlist || formattingViewModel.isDashList
        
        if (isList){
            var listSymbol: String = ""
            
            if formattingViewModel.isBulletlist {
                listSymbol = "• "
            } else if formattingViewModel.isDashList {
                listSymbol = "- "
            }
            
            if text == "\n" {
                guard let fullText = contentView.attributedText.mutableCopy() as? NSMutableAttributedString else { return true }
                
                let plainText = fullText.string as NSString
                let lineRange = plainText.lineRange(for: range)
                
                let currentLineText = plainText.substring(with: lineRange)
                
                if currentLineText.trimmingCharacters(in: .whitespaces).hasPrefix(listSymbol){
                    let insertion = "\n" + listSymbol
                    let insertionAttr = NSMutableAttributedString(string: insertion, attributes: textView.typingAttributes)
                    
                    fullText.replaceCharacters(in: range, with: insertionAttr)
                    textView.attributedText = fullText
                    textView.selectedRange = NSRange(location: lineRange.location + insertion.count, length: 0)
                    
                    return false
                }
            }
        }
        
        return true
    }
}
