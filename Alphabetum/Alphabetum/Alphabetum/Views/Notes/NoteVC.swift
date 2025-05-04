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
        
        formattingViewModel.toggle(format)
        
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
            let style = formattingViewModel.isActive(.underline) ? NSUnderlineStyle.single.rawValue : nil
            
            if hasSelection {
                applyAttribute(.underlineStyle, value: style, to: selectedRange)
            } else {
                contentView.typingAttributes[.underlineStyle] = style
            }
            break
        case .strikethrough:
            let style = formattingViewModel.isActive(.strikethrough) ? NSUnderlineStyle.single.rawValue : nil
            
            if hasSelection {
                applyAttribute(.strikethroughStyle, value: style, to: selectedRange)
            } else {
                contentView.typingAttributes[.strikethroughStyle] = style
            }
            break
        case .bulletlist, .dashList, .numberedList:
            insertListAtCurrentLine(format)
            break
        default:
            break
        }
    }
    
    private func fontWith(_ format: TextFormat, baseFont: UIFont) -> UIFont {
        switch format {
        case .bold:
            return formattingViewModel.isActive(.bold) ? UIFont.boldSystemFont(ofSize: baseFont.pointSize) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .italic:
            return formattingViewModel.isActive(.italic) ? UIFont.italicSystemFont(ofSize: baseFont.pointSize) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .title:
            return formattingViewModel.isActive(.title) ? UIFont.preferredFont(forTextStyle: .title1) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .header:
            return formattingViewModel.isActive(.header) ? UIFont.preferredFont(forTextStyle: .headline) : UIFont.systemFont(ofSize: baseFont.pointSize)
        case .subtitle:
            return formattingViewModel.isActive(.subtitle) ? UIFont.preferredFont(forTextStyle: .title2) : UIFont.systemFont(ofSize: baseFont.pointSize)
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
        var listSymbol: String = ""
        
        switch format {
        case .bulletlist:
            listSymbol = "• "
            break
        case .dashList:
            listSymbol = "- "
            break
        case .numberedList:
            listSymbol = "1. "
            break
        default:
            break
        }
        
        let selectedRange = contentView.selectedRange
        guard let fullText = contentView.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        
        let plainText = fullText.string as NSString
        let lineRange = plainText.lineRange(for: selectedRange)
        
        let lineText = plainText.substring(with: lineRange)
        if lineText.contains(listSymbol) {
            return
        }
        
        let bulletAttr = NSMutableAttributedString(string: listSymbol)
        fullText.insert(bulletAttr, at: lineRange.location)
        
        contentView.attributedText = fullText
        contentView.selectedRange = NSRange(location: selectedRange.location + listSymbol.count, length: 0)
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
        
        if text != "\n" { return true }
        
        guard let fullText = contentView.attributedText.mutableCopy() as? NSMutableAttributedString else { return true }
        
        let plainText = fullText.string as NSString
        let lineRange = plainText.lineRange(for: range)
        let currentLineText = plainText.substring(with: lineRange)
        
        var insertion: String?
        
        if formattingViewModel.isActive(.bulletlist) && currentLineText.hasPrefix("• "){
            insertion = "\n• "
        }
        
        else if formattingViewModel.isActive(.dashList) && currentLineText.hasPrefix("- "){
            insertion = "\n- "
        }
        
        else if formattingViewModel.isActive(.numberedList) {
            let components = currentLineText.components(separatedBy: ".")
            if let numberString = components.first,
               let number = Int(numberString) {
                let nextNumber = number + 1
                insertion = "\n\(nextNumber). "
            }
        }
        
        if let insertion = insertion {
            let insertionAttr = NSAttributedString(string: insertion, attributes: textView.typingAttributes)
            fullText.replaceCharacters(in: range, with: insertionAttr)
            textView.attributedText = fullText
            textView.selectedRange = NSRange(location: range.location + insertion.count, length: 0)
                    
            return false
        }

        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let range = textView.selectedRange
        let index = max(range.location, 0)
        
        guard index < textView.attributedText.length else { return }
        
        let attributes = textView.attributedText.attributes(at: index, effectiveRange: nil)
        let nsText = textView.attributedText.string as NSString
        let lineRange = nsText.lineRange(for: NSRange(location: index, length: 0))
        let lineText = nsText.substring(with: lineRange)
        
        var activeFormats: Set<TextFormat> = []
    
        var isBulletlist = false
        var isDashlist = false
        var isNumberedList = false
        
        if let font = attributes[.font] as? UIFont {
            let traits = font.fontDescriptor.symbolicTraits
            if traits.contains(.traitBold) { activeFormats.insert(.bold) }
            if traits.contains(.traitItalic) { activeFormats.insert(.italic) }
            activeFormats.insert(detectHeadingType(for: font))
        }
        
        if attributes[.underlineStyle] != nil { activeFormats.insert(.underline) }
        if attributes[.strikethroughStyle] != nil { activeFormats.insert(.strikethrough) }
        
        formattingViewModel.updateActiveFormats(activeFormats)
        textFormattingOptionsView.updateButtons(with: activeFormats)
    }
    
    func detectHeadingType(for font: UIFont) -> TextFormat {
        switch font.pointSize {
        case 28:
            return .title
        case 22:
            return .subtitle
        case 18:
            return .header
        default:
            return .body
        }
    }
    
    func detectListType(for lineText: String) -> TextFormat? {
        let trimmedText = lineText.trimmingCharacters(in: .whitespaces)
        
        if trimmedText.hasPrefix("• "){
            return .bulletlist
        }
        
        if trimmedText.hasPrefix("- "){
            return .dashList
        }
        
        let pattern = #"^\d+\.\s"# // regex: empieza con 1 o más dígitos + punto + espacio
        if let _ = trimmedText.range(of: pattern, options: .regularExpression) {
            return .numberedList
        }

        return nil
    }
}
