//
//  NoteCell.swift
//  Alphabetum
//
//  Created by David Gutierrez on 29/4/25.
//

import UIKit

/// Protocolo que permite gestionar los eventos de la celda desde otra vista.
protocol NoteCellDelegate: AnyObject {
    func noteCellRequestMenu(for cell: NoteCell) -> UIMenu
    func makePreviewViewController(for cell: NoteCell) -> NoteVC
}

/// Clase que representa la celda asociada a una nota.
class NoteCell: UITableViewCell {
    
    /// Identificador de la nota.
    static let reuseIdentifier = "NoteCell"
    
    /// Título de la nota
    private let title = UILabel()
    
    /// Botón de selección de nota
    private let selectionButton = UIButton()
    
    /// Objeto que permite manejar los eventos de la nota desde otras vistas
    weak var delegate: NoteCellDelegate?
    
    /// Constructor por defecto de clase en el que se configura el layout de la celda.
    /// - Parameters:
    ///   - style: estilo de la celda.
    ///   - reuseIdentifier: identificador de la celda.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title.text = "Sin título"
        
        configureSelectionButton()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Actualiza la vista de selección de la celda en función de su estado.
    /// - Parameters:
    ///   - isVisible: indica si el boton de selección es visible.
    ///   - isSelected: indica si la celda se ha seleccionado.
    func updateSelectionUI(isVisible: Bool, isSelected: Bool){
        selectionButton.isHidden = !isVisible
        let imageButton = (isSelected) ? "checkmark.circle.fill" : "circle"
        selectionButton.setImage(UIImage(systemName: imageButton), for: .normal)
    }
    
    /// Configura el título de la celda.
    /// - Parameter title: título de la celda.
    func configure(title: String){
        self.title.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Establece una interacción a llevar a cabo desde una vista padre.
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    /// Configura el layout de la celda.
    private func setupView() {
        contentView.addSubview(selectionButton)
        contentView.addSubview(title)

        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            selectionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionButton.widthAnchor.constraint(equalToConstant: 24),
            selectionButton.heightAnchor.constraint(equalToConstant: 24),

            title.leadingAnchor.constraint(equalTo: selectionButton.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    /// Configura el botón de selección de la vista.
    private func configureSelectionButton(){
        selectionButton.setImage(UIImage(systemName: "circle"), for: .normal)
        selectionButton.tintColor = .systemBlue
        selectionButton.isHidden = true
    }

}

/// Extensión que gestiona el manejo de un menu de interacción sobre la celda.
extension NoteCell: UIContextMenuInteractionDelegate {
    /// Crea un menu de interación que permite gestionar los eventos sobre la celda.
    /// - Parameters:
    ///   - interaction: interaciones que tendrá el menú.
    ///   - location: localización en la vista.
    /// - Returns: un objeto de tipo UIContextMenuConfiguration con un menu ya configurado.
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return self.delegate?.makePreviewViewController(for: self)
        }, actionProvider: { _ in
            return self.delegate?.noteCellRequestMenu(for: self)
        })
    }
    
    
}
