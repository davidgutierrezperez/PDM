//
//  DGSongSliderOption.swift
//  DGPlayer
//
//  Created by David Gutierrez on 6/4/25.
//

import UIKit

/// Clase que representa un *slider* de configuración en forma
/// de celda en una tabla.
class DGSongSliderOption: UITableViewCell {
    
    /// Identificador de la celda.
    static let reusableIdentifier = "SliderCell"
    
    /// Título de la celda.
    let titleCell = UILabel()
    
    /// Slider de la celda.
    let slider = UISlider()
    
    /// Clousure que permite obtener el valor del slider desde una vista padre.
    var onValueChanged: ((Float) -> Void)?
    
    /// Constructor por defecto de la celda. Configura el slider y su vista.
    /// - Parameters:
    ///   - style: estilo de la celda.
    ///   - reuseIdentifier: identificador de la celda.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DGSongSliderOption.reusableIdentifier)
        
        setupView()
        configureSlider(min: 0, max: 1, current: 0.5, isEnabled: true)
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        configure(title: "", min: 0, max: 1, current: 0.5, isEnabled: true)
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
    
    /// Configura los valores del slider.
    /// - Parameters:
    ///   - min: valor mínimo del slider.
    ///   - max: valor máximo del slider.
    ///   - current: valor actual del slider.
    ///   - isEnabled: indica si el slider está activo.
    private func configureSlider(min: Float, max: Float, current: Float, isEnabled: Bool){
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = current
        slider.isEnabled = isEnabled
    }
    
    /// Configura el título de la celda.
    /// - Parameter title: título de la celda.
    private func configureTitleCell(title: String){
        titleCell.text = title
        titleCell.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    /// Configura los distintos valores de la celda.
    /// - Parameters:
    ///   - title: título de la celda.
    ///   - min: valor mínimo de la celda.
    ///   - max: valor máximo de la celda.
    ///   - current: valor actual de la celda.
    ///   - isEnabled: indica si el slider está activo.
    func configure(title: String, min: Float, max: Float, current: Float, isEnabled: Bool){
        configureTitleCell(title: title)
        configureSlider(min: min, max: max, current: current, isEnabled: isEnabled)
    }
    
    /// Configura la vista de la celda.
    private func setupView(){
        contentView.addSubview(titleCell)
        contentView.addSubview(slider)
        
        titleCell.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    
            slider.topAnchor.constraint(equalTo: titleCell.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            slider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    /// Actualiza el valor del *slider*.
    @objc private func sliderChanged(){
        onValueChanged?(slider.value)
    }

}
