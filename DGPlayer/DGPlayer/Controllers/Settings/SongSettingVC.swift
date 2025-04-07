//
//  SongOptionsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

protocol SongSettingVCDelegate: AnyObject {
    func songSettingsDidUpdate(_ updateSettings: [SettingItem])
}

class SongSettingVC: UIViewController {
    
    var tableView : DGSongOptionsTableView!
    var settings: [SettingItem] = []
    
    weak var delegate: SongSettingVCDelegate?
    
    static let enableRateSetting:Int = 0
    static let volumeSliderSetting:Int = 1
    static let rateSliderSettting:Int = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureSettings()
        tableView = DGSongOptionsTableView(options: settings)
        configure()
        checkToggleSettings()
        checkSliderOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SongPlayerFooterVC.shared.hide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.songSettingsDidUpdate(settings)
    }
    
    
    private func activateEnableRateSetting(){
        guard settings.indices.contains(Self.rateSliderSettting) else { return }
        
        if case .slider(let min, let max, let current, _) = settings[Self.rateSliderSettting].type {
            settings[Self.rateSliderSettting].type = .slider(min: min, max: max, current: current, isEnabled: true)
            
            let rateSliderIndexPath = IndexPath(row: Self.rateSliderSettting, section: 1)
            tableView.tableView.reloadRows(at: [rateSliderIndexPath], with: .none)
        }
    }
    
    private func checkToggleSettings() {
        tableView.onToggleChanged = { [weak self] index, isOn in
            guard let self = self else { return }
            
            self.settings[index].type = .toggle(isOn: isOn)

            if (index == Self.enableRateSetting && isOn){
                activateEnableRateSetting()
            }

        }
    }
    
    private func checkSliderOptions(){
        tableView.onSliderChanged = { [weak self] index, newValue in
            guard let self = self else { return }

            let settingsIndex = Self.enableRateSetting + 1 + index // 👈 Corrige el offset

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

    
    private func configureSettings(){
        guard settings.isEmpty else { return }
        
        settings = [
            SettingItem(id: .enableRate, title: "Enable rate", type: .toggle(isOn: false)),
            SettingItem(id: .volume, title: "Volume", type: .slider(min: 0, max: 1, current: 0.3, isEnabled: true)),
            SettingItem(id: .rate, title: "Rate", type: .slider(min: 0, max: 2, current: 1, isEnabled: false))
        ]
    }

    
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
