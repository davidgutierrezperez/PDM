//
//  DGSongOptionsTableView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

/// Identificador de las diferentes celdas de la tabla.
private let reuseIdentifier = "Cell"

/// Controlador que maneja las celdas de configuración.
class DGSongOptionsTableView: UITableViewController {
    
    /// Ajustes en forma de botones.
    var toggleOptions: [SettingItem] = []
    
    /// Ajstes en forma de *sliders*.
    var sliderOptions: [SettingItem] = []
    
    /// Closure que permite acceder a los valores de configuración
    /// en forma de *slider* desde una vista padre.
    var onToggleChanged: ((Int, Bool) -> Void)?
    
    /// Closure que permite acceder a los valores de configuración
    /// en forma de botón desde una vista padre.
    var onSliderChanged: ((Int, Float) -> Void)?
    
    /// Constructor por defecto del controlador. Establece las
    /// distintas opciones de configuración.
    /// - Parameter options: opciones de configuración.
    init(options: [SettingItem]){
        super.init(style: .plain)
        
        for option in options {
            switch option.type {
            case .toggle:
                toggleOptions.append(option)
                break
            case .slider:
                sliderOptions.append(option)
                break
            }
        }
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
    
    /// Eventos que ocurren cuando la vista se carga por primera vez.
    /// Configura las diferentes celdas de la tabla.
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DGSongToggleOption.self, forCellReuseIdentifier: DGSongToggleOption.reusableIdentifier)
        tableView.register(DGSongSliderOption.self, forCellReuseIdentifier: DGSongSliderOption.reusableIdentifier)
        
        tableView.separatorStyle = .none
    }

    
    /// Indica el número de secciones de la tabla.
    /// - Parameter tableView: tabla del controlador.
    /// - Returns: número de secciones de la tabla.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Indica el número de filas por sección.
    /// - Parameters:
    ///   - tableView: tabla del controlador.
    ///   - section: sección de la tabla.
    /// - Returns: número de filas por sección de la tabla.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? toggleOptions.count : sliderOptions.count
    }

    
    /// Configura  las diferentes celdas de la tabla.
    /// - Parameters:
    ///   - tableView: tabla del controlador.
    ///   - indexPath: índice de cada celda.
    /// - Returns: celdas de la tabla tras ser configuradas.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = (indexPath.section == 0) ? toggleOptions[indexPath.row] : sliderOptions[indexPath.row]

        switch setting.type {
        case .toggle(let isOn):
            let cell = tableView.dequeueReusableCell(withIdentifier: DGSongToggleOption.reusableIdentifier, for: indexPath) as! DGSongToggleOption
            cell.configure(text: setting.title, isEnabled: isOn)
            
            cell.switchAction = { [weak self] newValue in
                self?.onToggleChanged?(indexPath.row, newValue)
                
            }
            
            return cell

        case .slider(let min, let max, let current, let isEnabled):
            let cell = tableView.dequeueReusableCell(withIdentifier: DGSongSliderOption.reusableIdentifier, for: indexPath) as! DGSongSliderOption
            cell.configure(title: setting.title, min: min, max: max, current: current, isEnabled: isEnabled)
            
            cell.onValueChanged = { [weak self] newValue in
                self?.onSliderChanged?(indexPath.row, newValue)
                
            }
            
            return cell
        }
    }

}
