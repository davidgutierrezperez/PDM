//
//  TrainingTypeCell.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class TrainingTypeCell: UITableViewCell {
    
    static let reuseIdentifier = "TrainingTypeCell"
    
    private let icon = UIImageView()
    private let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: TrainingType){
        switch type {
        case .FREE_RUN:
            title.text = "Carrera libre"
            icon.image = UIImage(systemName: SFSymbols.runner) ?? UIImage()
            break
        case .DISTANCE_INTERVAL:
            title.text = "Intervalos de distancia"
            icon.image = UIImage(systemName: SFSymbols.runner_in_square) ?? UIImage()
            break
        case .TIME_INTERVAL:
            title.text = "Intervalos de tiempo"
            icon.image = UIImage(systemName: SFSymbols.clock) ?? UIImage()
            break
        }
    }
    
    private func setupView(){
        contentView.addSubview(icon)
        contentView.addSubview(title)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = AppColors.primary
        layer.borderColor = nil
        
        NSLayoutConstraint.activate([
            // Icono a la izquierda, centrado verticalmente
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            // Título a la derecha del icono, centrado verticalmente
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

    }

}
