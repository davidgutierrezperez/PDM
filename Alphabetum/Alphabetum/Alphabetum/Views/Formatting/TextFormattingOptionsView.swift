//
//  TextFormattingOptionsView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

/// Clase que representa la vista con todas las opciones de
class TextFormattingOptionsView: TextFormatPanelHorizontalView {
    
    /// Botón que permite acceder al panel de selección de formato de texto.
    private let formattingTextButton = UIButton()
    
    /// Botón que permite acceder al menú de inserción de imágenes.
    private let insertImageButton = UIButton()
    
    /// Panel de formatos de texto (bold, italic, etc).
    private let textFormatOptionsPanel = TextBodyFormatPanelView()
    
    /// Panel de formatos de título de texto.
    private let textHeadingFormatOptionsPanel = TextHeadingFormatPanelView()
    
    /// Panel de listas de texto.
    private let textListFormatOptionsPanel = TextListFormatPanelView()
    
    /// Objeto que agrupa verticalmente los diferents paneles de formato de texto.
    private let verticalStackView = UIStackView()
    
    /// Indica el formato seleccionado.
    var onFormatTap: ((TextFormat) -> Void)?
    
    /// Indica el tipo de fuente de la que proviene la imagen a insertar.
    var onImageButtonTap: ((ImageInputSource) -> Void)?
    
    /// Constructor por defecto. Configura el layout de los paneles.
    /// - Parameter frame: forma de la vista.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .darkGray
        
        configureTextFormatOptionsPanel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Actualiza los botones en función de los formatos activos en el texto.
    /// - Parameter formats: conjunto de formatos activos.
    func updateButtons(with formats: Set<TextFormat>){
        textFormatOptionsPanel.updateButtons(with: formats)
        textHeadingFormatOptionsPanel.updateButtons(with: formats)
        textListFormatOptionsPanel.updateButtons(with: formats)
    }
    
    
    /// Configura los botones de la vista.
    override func configureButtons(){
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        
        formattingTextButton.setImage(UIImage(systemName: "textformat", withConfiguration: buttonConfig), for: .normal)
        formattingTextButton.addTarget(self, action: #selector(showTextFormattingOptions), for: .touchUpInside)
        
        insertImageButton.setImage(UIImage(systemName: "paperclip", withConfiguration: buttonConfig), for: .normal)
        insertImageButton.menu = createImageOptionMenu()
        insertImageButton.showsMenuAsPrimaryAction = true
        
        formattingTextButton.tintColor = .systemYellow
        insertImageButton.tintColor = .systemYellow
    }
    
    /// Configura el panel principal de la vista.
    override func configureStackView(){
        super.configureStackView()
        
        stackView.addArrangedSubview(formattingTextButton)
        stackView.addArrangedSubview(insertImageButton)
    }
    
    /// Configura el panel vertical de formatos de texto.
    private func configureVerticalStackView(){
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 15
        verticalStackView.alignment = .center
        verticalStackView.distribution = .equalCentering
    }
    
    /// Evento que gestiona la aparición de los diferentes panales de formato de texto.
    @objc private func showTextFormattingOptions() {
        let shoudExpand = verticalStackView.arrangedSubviews.isEmpty
        
        if shoudExpand {
            verticalStackView.addArrangedSubview(textFormatOptionsPanel)
            verticalStackView.addArrangedSubview(textListFormatOptionsPanel)
            verticalStackView.addArrangedSubview(textHeadingFormatOptionsPanel)
        } else {
            textFormatOptionsPanel.removeFromSuperview()
            textListFormatOptionsPanel.removeFromSuperview()
            textHeadingFormatOptionsPanel.removeFromSuperview()
        }
        
        verticalStackView.isHidden.toggle()

        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    
    
    /// Configura el layout del panel vertical para los formatos de texto.
    private func configureTextFormatOptionsPanel() {
        addSubview(verticalStackView)

        verticalStackView.isHidden = true
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints para que se vea y ocupe espacio
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Propagar los closures
        textFormatOptionsPanel.onFormatTap = { [weak self] format in
            self?.onFormatTap?(format)
        }
        
        textListFormatOptionsPanel.onFormatTap = { [weak self] format in
            self?.onFormatTap?(format)
        }

        textHeadingFormatOptionsPanel.onFormatTap = { [weak self] format in
            self?.onFormatTap?(format)
        }

        configureVerticalStackView()
    }
    
    /// Crea una menu que permite seleccionar la forma de obtener una imagen para insertar en una nota.
    /// - Returns: un objeto de tipo UIMeny con sus diferentes acciones.
    private func createImageOptionMenu() -> UIMenu {
        let imageMenu = UIMenu(title: "Insert image", children: [
            UIAction(title: "Choose an image", image: UIImage(systemName: "photo")) { [weak self] _ in
                self?.onImageButtonTap?(.gallery)
            },
            UIAction(title: "Take a picture", image: UIImage(systemName: "camera")) { [weak self] _ in
                self?.onImageButtonTap?(.camera)
            }
        ])
        return imageMenu
    }
    
    override var intrinsicContentSize: CGSize {
        let baseHeight: CGFloat = 50
        
        guard !verticalStackView.isHidden else {
            return CGSize(width: UIView.noIntrinsicMetric, height: baseHeight)
        }
        
        let panelHeight = verticalStackView.systemLayoutSizeFitting(
                CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height)
            ).height
        
        return CGSize(width: UIView.noIntrinsicMetric, height: panelHeight + baseHeight)
    }

}


