//
//  DGSongOption.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

/// Clase que representa un botón de configuración en forma
/// de celda en una tabla.
class DGSongToggleOption: UITableViewCell {
    
    /// Identificador de la celda.
    static let reusableIdentifier = "DGSongOption"
        
    /// Título de la celda.
    var titleLabel = UILabel()
    
    /// Botón de tipo *switch*.
    var toggleSwitch = UISwitch()
    
    /// Indica si el botón está activo.
    var isOptionEnabled: Bool = false
    
    /// Clousure que permite obtener el valor del botón
    /// desde una vista padre.
    var switchAction: ((Bool) -> Void)?
    
    /// Constructor por defecto de la celda.
    /// - Parameters:
    ///   - style: estilo de la celda.
    ///   - reuseIdentifier: identificador de la celda.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        configureToggleSwitch()
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
    
    /// Configura el texto de la celda.
    /// - Parameter title: título de la celda.
    private func configureLabel(title: String){
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Configura el *switch* del botón.
    private func configureToggleSwitch(){
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.onTintColor = .systemGreen
        
        toggleSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    
    /// Actualiza el valor del botón.
    /// - Parameter sender: *switch* que actualiza su valor.
    @objc private func switchChanged(_ sender: UISwitch){
        isOptionEnabled = sender.isOn
        switchAction?(sender.isOn)
    }
    
    /// Configura la celda y su vista.
    /// - Parameters:
    ///   - text: texto de la celda.
    ///   - isEnabled: indica si el boton está activo.
    func configure(text: String, isEnabled: Bool) {
        titleLabel.text = text
        isOptionEnabled = isEnabled

        toggleSwitch.removeTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        toggleSwitch.isOn = isEnabled
        toggleSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)


        if titleLabel.superview == nil {
            contentView.addSubview(titleLabel)
            contentView.addSubview(toggleSwitch)

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            toggleSwitch.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }

    
}
