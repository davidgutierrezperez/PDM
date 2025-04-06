//
//  DGCell.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

/// Objecto que representa una celda un vista representada por una tabla.
class DGCell: UITableViewCell {
    
    /// Identificador de la tabla.
    static let reusableIdentifier = "DGCell"
    
    /// Título o texto de la celda.
    private let title = UILabel()
    
    /// Imagen a mostrar en la celda.
    private let image = UIImageView()

    /// Constructor por defecto de la celda.
    /// - Parameters:
    ///   - style: estilo a mostrar en la celda.
    ///   - reuseIdentifier: identificador de la celda.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupViews()
    }
    
    /// Inicializador requerido para cargar la vista desde un archivo storyboard o nib.
    ///
    /// Este inicializador es necesario cuando se utiliza Interface Builder para crear
    /// instancias del controlador. En este caso particular, como el controlador se
    /// configura completamente de forma programática, el uso de storyboards no está soportado,
    /// por lo que se lanza un `fatalError` si se intenta usar.
    ///
    /// - Parameter coder: Objeto utilizado para decodificar la vista desde un archivo nib o storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura la vista y añade sus elementos.
    private func setupViews(){
        image.clipsToBounds = true
        image.layer.cornerRadius = 6
        title.font = UIFont.boldSystemFont(ofSize: 16)

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        contentView.addSubview(image)
        contentView.addSubview(title)

        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        image.contentMode = .scaleAspectFit
        image.tintColor = nil
    }
    
    func configure(cellTitle: String, cellImage: UIImage?) {
        title.text = cellTitle
        
        image.image = nil
        image.tintColor = nil
        image.contentMode = .scaleAspectFit

            if let cellImage = cellImage,
               cellImage != UIImage(systemName: "music.note") {
                image.image = cellImage
                image.contentMode = .scaleAspectFill
            } else {
                let symbolImage = UIImage(systemName: "music.note")?
                    .withRenderingMode(.alwaysTemplate)
                image.image = symbolImage
                image.tintColor = .systemGray
                image.contentMode = .scaleAspectFit
            }

    }
    
}
