//
//  DGCell.swift
//  DGPlayer
//
//  Created by David Gutierrez on 11/3/25.
//

import UIKit

class DGCell: UITableViewCell {
    
    static let reusableIdentifier = "DGCell"
    
    private let title = UILabel()
    private let image = UIImageView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cellTitle: String, cellImage: UIImage?) {
        title.text = cellTitle
        image.image = (cellImage != nil) ? cellImage : UIImage(systemName: "music.note")
        image.contentMode = (cellImage != nil) ? .scaleAspectFill : .scaleAspectFit

        image.clipsToBounds = true
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true

        // Configuración de estilos
        title.font = UIFont.boldSystemFont(ofSize: 16)

        // Fondo gris claro con bordes redondeados
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        // Agregar subviews
        contentView.addSubview(image)
        contentView.addSubview(title)

        // Desactivar AutoResizingMask
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
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

    

    
    
    
    
}
