//
//  NoteViewController.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

/// Clase que representa la vista de una nota y su información.
class NoteVC: UIViewController {
    
    /// Objeto que gestiona las consultas relacionadas con notas a CoreData.
    private let noteRepository = NoteRepository()
    
    /// Objeto que gestiona la información de una nota.
    private let viewModel: NoteViewModel
    
    /// Objeto que gestiona la información relacionada con el formato de texto de una nota.
    private let formattingViewModel: TextFormattingViewModel
    
    /// Campo de texto para el título de la nota.
    private var titleField = UITextField()
    
    /// Campo de texto para el contenido de una nota.
    private var contentView = UITextView()
    
    /// Botón que permite acceder a la vista de selección de una carpeta para la nota.
    private var selectFolderButton = UIBarButtonItem()
    
    /// Botón que permite hacer desaparecer el teclado cuando se está escribiendo
    private var disableKeyboardButton = UIBarButtonItem()
    
    /// Objeto que representa el panel con las diferentes opciones de formato de texto
    private let textFormattingOptionsView = TextFormattingOptionsView()
    
    
    /// Constructor por defecto. Se crea una nota vacía sin contenido alguno.
    init() {
        self.viewModel = NoteViewModel()
        self.formattingViewModel = TextFormattingViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Constructor mediante identificador. Se accede a la información de una nota
    /// previamente guardada.
    /// - Parameter id: identificador de la vista.
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
    
    /// Eventos a ocurrir cuando se carga la vista por primera vez. Se configura el aspecto visual
    /// de la vista y su layout.
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    /// Eventos a ocurrir cuando se carga la vista nuevamente. El contenido de
    /// la nota se vuelve el objeto principal.
    /// - Parameter animated: indica si la aparición de la vista debe ser animada.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.becomeFirstResponder()
        contentView.reloadInputViews()
    }
    
    /// Oculta la vista con los paneles de formatos de texto.
    func hideFormattingViewOptions(){
        textFormattingOptionsView.isHidden = true
    }
    
    /// Gestiona el evento de aparición del teclado.
    /// - Parameter notification: notificación que indica que el teclado debe aparecer.
    @objc private func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let bottomInset = keyboardFrame.height
        contentView.contentInset.bottom = bottomInset
        contentView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    /// Gestiona el evento de desaparición del teclado.
    /// - Parameter notification: notificación que indica que el teclado debe desaparecer.
    @objc private func keyboardWillHide(notification: Notification){
        contentView.contentInset.bottom = 0
        contentView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    /// Configura los paneles con botones de formato de texto y actualiza sus estados.
    private func configureTextFormattingOptionsView(){
        textFormattingOptionsView.onFormatTap = { [weak self] format in
            self?.toggleFormating(format)
        }
        
        textFormattingOptionsView.onImageButtonTap = { [weak self] inputSource in
            self?.presentImagePicker(sourceType: (inputSource == .camera) ? .camera : .photoLibrary)
        }
    }
    
    /// Muestra una pestaña que permite obtener una imagen para insertar en la nota.
    /// - Parameter sourceType: tipo de pestaña a mostrar.
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
    
    /// Actualiza el estado de un formato en función de lo que se haya seleccionado en el panel de formatos.
    /// - Parameter format: formato seleccionado.
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
    
    /// Establece el tipo de fuente a utilizar en función del formato seleccionado.
    /// - Parameters:
    ///   - format: formato seleccionado.
    ///   - baseFont: fuente por defecto del texto.
    /// - Returns: un objeto de tipo UIFont que representa la fuente a utilizar en el texto.
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
    
    /// Aplica los atributos seleccionados sobre el texto de la nota.
    /// - Parameters:
    ///   - key: atributo a modificar.
    ///   - value: valor del atributo.
    ///   - range: rango del texto sobre el que se aplicará el atributo.
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
    
    /// Inserta una lista en el texto seleccionado.
    /// - Parameter format: formato de lista seleccionado.
    private func insertListAtCurrentLine(_ format: TextFormat) {
        var listSymbol = ""
        
        switch format {
        case .bulletlist:
            listSymbol = "• "
        case .dashList:
            listSymbol = "- "
        case .numberedList:
            listSymbol = "1. "
        default:
            return
        }
        
        let selectedRange = contentView.selectedRange
        guard let fullText = contentView.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        
        let plainText = fullText.string as NSString
        let selectionRange = plainText.lineRange(for: selectedRange)
        let selectedText = plainText.substring(with: selectionRange)
        
        let lines = selectedText.components(separatedBy: .newlines)
        var offset = 0
        
        for (index, line) in lines.enumerated() {
            let lineStart = plainText.lineRange(for: NSRange(location: selectionRange.location + offset, length: 0)).location
            if !line.trimmingCharacters(in: .whitespaces).hasPrefix(listSymbol) {
                let symbol = (format == .numberedList) ? "\(index + 1). " : listSymbol
                let symbolAttr = NSMutableAttributedString(string: symbol, attributes: contentView.typingAttributes)
                fullText.insert(symbolAttr, at: lineStart)
                offset += symbol.count
            } else {
                offset += 0
            }
            offset += (line as NSString).length + 1 // +1 for newline
        }
        
        contentView.attributedText = fullText
        contentView.selectedRange = NSRange(location: selectedRange.location + listSymbol.count, length: selectedRange.length)
    }

    
    /// Evento que gestiona la actualización del título de la nota.
    @objc private func updateTitle(){
        viewModel.updateTitle(titleField.text!)
    }
    
    /// Evento que gestiona la actualización de contenido.
    @objc private func updateContent(){
        let newContent = contentView.attributedText?.mutableCopy() as? NSMutableAttributedString
        viewModel.updateContent(newContent ?? NSMutableAttributedString(""))
    }
    
    /// Evento que gestiona la selección de una carpeta a la que se añadirá una nota.
    @objc private func selectFolder(){
        let folderPickerVC = FolderPickerVC(note: viewModel.getNote())
        let navVC = UINavigationController(rootViewController: folderPickerVC)
        
        present(navVC, animated: true)
    }
    
    /// Evento que gestiona la desapirición del teclado.
    @objc private func disableKeyboard(){
        contentView.endEditing(true)
    }
    
    /// Configura el layout de la vista.
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
    
    /// Configura los campos de texto del título y del contenido de la nota.
    private func configureTextFields(){
        titleField.addTarget(self, action: #selector(updateTitle), for: .editingChanged)
        titleField.font = .preferredFont(forTextStyle: .title1)
        titleField.borderStyle = .roundedRect
        
        contentView.delegate = self
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        
    }
    
    /// Configura los botones de la vista.
    private func configureButtons(){
        selectFolderButton = createBarButton(image: UIImage(systemName: "folder.badge.plus") ?? UIImage(), selector: #selector(selectFolder))
        disableKeyboardButton = createBarButton(image: UIImage(systemName: "checkmark") ?? UIImage(), selector: #selector(disableKeyboard))
    }
}

/// Extensión que gestiona los eventos relacionados con los campos de texto
extension NoteVC: UITextViewDelegate {
    
    /// Actualiza y guarda el contenido de una nota cuando termina de editarse.
    /// - Parameter textView: campo de texto editado.
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateContent(textView.attributedText.mutableCopy() as! NSMutableAttributedString)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - textView: <#textView description#>
    ///   - range: <#range description#>
    ///   - text: <#text description#>
    /// - Returns: <#description#>
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

extension NoteVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        contentView.insertImage(image)
        updateContent()
    }
}

