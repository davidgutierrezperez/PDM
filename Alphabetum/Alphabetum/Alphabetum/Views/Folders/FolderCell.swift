//
//  FolderCell.swift
//  Alphabetum
//
//  Created by David Gutierrez on 23/4/25.
//

import UIKit

/// Protocolo que permite gestionar los eventos de la celda
/// desde otras vistas.
protocol FolderCellDelegate: AnyObject {
    func folderCellRequestMenu(for cell: FolderCell) -> UIMenu
}

/// Clase que representa una celda con la información de una carpeta.
class FolderCell: UITableViewCell {
    
    /// Identificador de la celda.
    static let reusableIdentifier = "FolderCell"
    
    /// Título de la carpeta asociada a la celda.
    private let title = UILabel()
    
    /// Icono a mostrar en cada celda.
    private var icon = UIImageView()
    
    /// Número de notas que tiene la carpeta asociada a la celda.
    private var numberOfNotes = UILabel()
    
    /// Variable que permite gestionar los eventos de la celda desde
    /// otras vistas.
    weak var delegate: FolderCellDelegate?
    
    /// Constructor por defecto de la celda. Configura su estilo y su vista.
    /// - Parameters:
    ///   - style: estilo de la celda.
    ///   - reuseIdentifier: identificador de la celda.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureIcon()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura la información de la celda.
    /// - Parameters:
    ///   - title: título de la carpeta asociada a la celda.
    ///   - numberOfNotes: número de notas de la carpeta asociada a la celda.
    func configure(title: String, numberOfNotes: Int = 0){
        configureTitle()
        
        self.title.text = title
        configureNumberOfNotes(numberOfNotes: numberOfNotes)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Añade una interación cuando se produce un evento desde una vista padre.
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    /// Configura el icono de la celda.
    private func configureIcon(){
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        icon = UIImageView(image: UIImage(systemName: "folder", withConfiguration: imageConfiguration))
        
        icon.tintColor = .systemYellow
    }
    
    /// Configura el título de la celda.
    private func configureTitle(){
        title.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func configureNumberOfNotes(numberOfNotes: Int){
        self.numberOfNotes.text = (numberOfNotes > 0) ? String(numberOfNotes) : ""
        self.numberOfNotes.text? += " >"
        self.numberOfNotes.font = UIFont.systemFont(ofSize: 12)
        self.numberOfNotes.textColor = .secondaryLabel
        self.numberOfNotes.textAlignment = .right
    }
    
    /// Configura la vista de la celda.
    private func setupView() {
        contentView.addSubview(title)
        contentView.addSubview(icon)
        contentView.addSubview(numberOfNotes)

        title.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        numberOfNotes.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .systemGray3

        NSLayoutConstraint.activate([
            // Icono de la carpeta
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),

            // Label de número de notas
            numberOfNotes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            numberOfNotes.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // Título de la carpeta
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: numberOfNotes.leadingAnchor, constant: -8),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }


}

extension FolderCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return self.delegate?.folderCellRequestMenu(for: self)
        }
    }
    
    
}
