//
//  SongOptionsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

/// Protocolo que permite a SongPlayerVC actualizar los
/// ajustes del reproductor de música.
protocol SongSettingVCDelegate: AnyObject {
    func songSettingsDidUpdate(_ updateSettings: [SettingItem])
}

/// Controlador que permite configurar los ajustes del reproductor de música
class SongSettingVC: UIViewController {
    
    /// Tabla que contiene las distintas opciones de configuración.
    var tableView : DGSongOptionsTableView!
    
    /// Lista de opciones de configuración.
    var settings: [SettingItem] = []
    
    /// Objecto que permite actualizar los ajutes desde una vista padre.
    weak var delegate: SongSettingVCDelegate?
    
    /// Número de configuración para ajustar la habilitación de
    /// la velocidad de reproducción.
    static let enableRateSetting:Int = 0
    
    /// Número de configuración para ajustar el volumen de la canción.
    static let volumeSliderSetting:Int = 1
    
    /// Número de configuración para ajustar la velocidad de reproducción.
    static let rateSliderSettting:Int = 2
    
    /// Eventos que se producen cuando se carga la vista por primera vez. Se
    /// configura la vista y se comprueban las distintas opciones.
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureSettings()
        tableView = DGSongOptionsTableView(options: settings)
        configure()
        checkToggleSettings()
        checkSliderOptions()
    }
    
    /// Eventos que se producen cuando la vista se carga de nuevo.
    /// Se oculta SongPlayerFooterVC.
    /// - Parameter animated: <#animated description#>
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SongPlayerFooterVC.shared.hide()
    }
    
    /// Eventos que se producen cuando la vista desaparece. Se
    /// actualizan los ajustes de reproducción de canciones.
    /// - Parameter animated: <#animated description#>
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.songSettingsDidUpdate(settings)
    }
    
    /// Comprueba si ha habilitado la opción de configurar la velocidad de
    /// reproducción.
    /// - Returns: **true** si se habilitado la velocidad de reproducción y **false**
    /// en caso contrario.
    func isRateEnabled() -> Bool {
        guard settings.indices.contains(Self.enableRateSetting) else { return false }
        
        if case .toggle(let isOn) = settings[Self.enableRateSetting].type {
            return isOn
        }
        
        return false
    }
    
    /// Activa la configuración de ajuste de velocidad de reproducción.
    private func activateEnableRateSetting(){
        guard settings.indices.contains(Self.rateSliderSettting) else { return }
        
        if case .slider(let min, let max, let current, _) = settings[Self.rateSliderSettting].type {
            settings[Self.rateSliderSettting].type = .slider(min: min, max: max, current: current, isEnabled: true)
            
            let rateSliderIndexPath = IndexPath(row: Self.rateSliderSettting, section: 1)
            tableView.tableView.reloadRows(at: [rateSliderIndexPath], with: .none)
        }
    }
    
    /// Comprueba las opciones de configuración mediante botones.
    private func checkToggleSettings() {
        tableView.onToggleChanged = { [weak self] index, isOn in
            guard let self = self else { return }

            self.settings[index].type = .toggle(isOn: isOn)

            if index == Self.enableRateSetting {
                if case .slider(let min, let max, let current, _) = self.settings[Self.rateSliderSettting].type {
                    self.settings[Self.rateSliderSettting].type = .slider(min: min, max: max, current: current, isEnabled: isOn)
   
                    let rateIndexInSliders = Self.rateSliderSettting - (Self.enableRateSetting + 1)
                    let rateIndexPath = IndexPath(row: rateIndexInSliders, section: 1)
                    self.tableView.tableView.reloadRows(at: [rateIndexPath], with: .none)
                }
            }
        }
    }

    
    /// Comprueba las opciones de configuración mediante *sliders*.
    private func checkSliderOptions(){
        tableView.onSliderChanged = { [weak self] index, newValue in
            guard let self = self else { return }

            let settingsIndex = Self.enableRateSetting + 1 + index

            guard settingsIndex < self.settings.count else { return }

            if case .slider(let min, let max, _, let isEnabled) = self.settings[settingsIndex].type {
                self.settings[settingsIndex].type = .slider(min: min, max: max, current: newValue, isEnabled: isEnabled)
            }

            if case .slider(let min, let max, _, let isEnabled) = self.tableView.sliderOptions[index].type {
                self.tableView.sliderOptions[index].type = .slider(min: min, max: max, current: newValue, isEnabled: isEnabled)
            }

            self.delegate?.songSettingsDidUpdate(self.settings)
        }
    }
    
    /// Configura las distintas opciones a mostrar en la vista.
    private func configureSettings(){
        guard settings.isEmpty else { return }
        
        settings = [
            SettingItem(id: .enableRate, title: "Enable rate", type: .toggle(isOn: false)),
            SettingItem(id: .volume, title: "Volume", type: .slider(min: 0, max: 1, current: 0.3, isEnabled: true)),
            SettingItem(id: .rate, title: "Rate", type: .slider(min: 0, max: 2, current: 1, isEnabled: false))
        ]
    }
    
    /// Configura el layout de la vista.
    private func configure(){
        tableView.tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView.tableView)
                
        NSLayoutConstraint.activate([
            tableView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

}
