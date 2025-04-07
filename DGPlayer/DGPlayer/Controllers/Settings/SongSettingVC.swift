//
//  SongOptionsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

class SongSettingVC: UIViewController {
    
    var tableView : DGSongOptionsTableView!
    var settings: [SettingItem] = []
    
    static let loopingSettingNumber:Int = 0
    static let randomSongSettingNumber:Int = 1


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureSettings()
        tableView = DGSongOptionsTableView(options: settings)
        configure()
        checkToggleSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SongPlayerFooterVC.shared.hide()
    }
    
    func isLoopingSettingActivated() -> Bool {
        guard settings.indices.contains(Self.loopingSettingNumber) else { return false }
        
        let setting = settings[Self.loopingSettingNumber]
        
        if case .toggle(let isOn) = setting.type {
            return isOn
        }
        
        return false
    }
    
    func isRandomSongSettingActivated() -> Bool {
        guard settings.indices.contains(Self.randomSongSettingNumber) else { return false }
        
        let setting = settings[Self.randomSongSettingNumber]
        
        if case .toggle(let isOn) = setting.type {
            return isOn
        }
        
        return false
    }
    
    private func deactivateRandomIfLoopingActivated(){
        guard settings.indices.contains(Self.randomSongSettingNumber),
              settings.indices.contains(Self.loopingSettingNumber) else { return }
        
        if case .toggle(true) = settings[Self.loopingSettingNumber].type {
            settings[Self.randomSongSettingNumber].type = .toggle(isOn: false)
        }
    }
    
    private func deactivateLoopingIfRandomSongActivated(){
        guard settings.indices.contains(Self.randomSongSettingNumber),
              settings.indices.contains(Self.loopingSettingNumber) else { return }
        
        if case .toggle(true) = settings[Self.randomSongSettingNumber].type {
            settings[Self.loopingSettingNumber].type = .toggle(isOn: false)
        }
    }
    
    private func checkToggleSettings() {
        tableView.onToggleChanged = { [weak self] index, isOn in
            guard let self = self else { return }
            
            let randomIndexPath = IndexPath(row: Self.randomSongSettingNumber, section: 0)
            let loopingIndexPath = IndexPath(row: Self.loopingSettingNumber, section: 0)
            
            self.settings[index].type = .toggle(isOn: isOn)
            
            if (index == Self.loopingSettingNumber && isOn){
                deactivateRandomIfLoopingActivated()
                self.tableView.tableView.reloadRows(at: [randomIndexPath], with: .none)
            } else if (index == Self.randomSongSettingNumber && isOn){
                deactivateLoopingIfRandomSongActivated()
                self.tableView.tableView.reloadRows(at: [loopingIndexPath], with: .none)
            }

        }
    }
    
    private func configureSettings(){
        guard settings.isEmpty else { return }
        
        settings = [
                SettingItem(title: "Repetir canción", type: .toggle(isOn: false)),
                SettingItem(title: "Reproducción aleatoria", type: .toggle(isOn: false)),
                SettingItem(title: "Graves", type: .slider(current: 0.5)),
                SettingItem(title: "Medios", type: .slider(current: 0.5)),
                SettingItem(title: "Agudos", type: .slider(current: 0.5)),
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
