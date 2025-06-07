//
//  ActivityDetailVerticalStackView.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import UIKit

/// Clase que representa un componente que agrupa elementos
/// visuales de forma vertical
class ActivityDetailVerticalStackView: UIStackView {
    
    /// Contenido del componente
    private let valueLabel = UILabel()
    
    /// Título del componente
    private let titleLabel = UILabel()
    
    /// Tamaño del contenido
    private var valueSize:CGFloat = 24
    
    /// Constructor por defecto del stack. Se configura el tamaño de los elementos y su alineación.
    /// - Parameters:
    ///   - valueSize: tamaño del contenido del stack.
    ///   - alignment: alineamento del stack.
    ///   - largeValue: índica si el contenido del componente debe mostrarse en grande.
    init(valueSize: CGFloat = 24, alignment: UIStackView.Alignment = .leading, largeValue: Bool = false){
        self.valueSize = valueSize
        
        super.init(frame: CGRect())
        
        axis = .vertical
        distribution = .equalCentering
        spacing = 10
        
        self.alignment = alignment
        
        if (largeValue){
            self.valueSize = 48
        }
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configura el componente con los valores a mostrar.
    /// - Parameters:
    ///   - value: contenido del componente.
    ///   - title: título del componente.
    func configure(value: String, title: String){
        valueLabel.text = value
        titleLabel.text = title
    }
    
    /// Actualiza el valor del componente
    /// - Parameter newValue: nuevo valor del componente.
    func updateValue(newValue: String){
        valueLabel.text = newValue
    }
    
    /// Configura la interfaz visual del componente stack.
    private func setupView(){
        addArrangedSubview(valueLabel)
        addArrangedSubview(titleLabel)
        
        configureLabels()
    }
    
    /// Configura el texto mostrado en el componente.
    private func configureLabels(){
        valueLabel.font = UIFont.boldSystemFont(ofSize: valueSize)
        titleLabel.textColor = AppColors.statisticOptionLabel
    }

}
