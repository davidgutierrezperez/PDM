//
//  TextFormatPanelHorizontalView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

/// Clase que representa una vista con un panel horizontal.
class TextFormatPanelHorizontalView: UIView {
    
    /// Objeto que agrupa los dfierentes botones en horizontal
    let stackView = UIStackView()
    
    /// Constructor por defecto de la clase. Configura los diferentes elementos
    /// y el layout de la vista.
    /// - Parameter frame: forma de la vista.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray2
        
        configureButtons()
        configureStackView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Función a sobreescribir. Configura los diferentes botones del panel.
    func configureButtons(){}
    
    /// Configura el stackView del panel.
    func configureStackView(){
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
    }
    
    /// Configura el layout de la vista.
    func setupView(){
        addSubview(stackView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
