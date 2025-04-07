//
//  SongOptionsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

class SongOptionsVC: UIViewController {
    
    var tableView : DGSongOptionsTableView!
    var options: [SettingItem] = []
    
    static let loopingSettingNumber:Int = 0
    static let randomSongSettingNumber:Int = 1


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureOptions()
        tableView = DGSongOptionsTableView(options: options)
        configure()
        checkToggleOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SongPlayerFooterVC.shared.hide()
    }
    
    func isLoopingSettingActivated() -> Bool {
        guard options.indices.contains(Self.loopingSettingNumber) else { return false }
        
        let setting = options[Self.loopingSettingNumber]
        
        if case .toggle(let isOn) = setting.type {
            return isOn
        }
        
        return false
    }
    
    func isRandomSongSettingActivated() -> Bool {
        guard options.indices.contains(Self.randomSongSettingNumber) else { return false }
        
        let setting = options[Self.randomSongSettingNumber]
        
        if case .toggle(let isOn) = setting.type {
            return isOn
        }
        
        return false
    }
    
    private func deactivateRandomIfLoopingActivated(){
        guard options.indices.contains(Self.randomSongSettingNumber),
              options.indices.contains(Self.loopingSettingNumber) else { return }
        
        if case .toggle(true) = options[Self.loopingSettingNumber].type {
            options[Self.randomSongSettingNumber].type = .toggle(isOn: false)
        }
    }
    
    private func deactivateLoopingIfRandomSongActivated(){
        guard options.indices.contains(Self.randomSongSettingNumber),
              options.indices.contains(Self.loopingSettingNumber) else { return }
        
        if case .toggle(true) = options[Self.randomSongSettingNumber].type {
            options[Self.loopingSettingNumber].type = .toggle(isOn: false)
        }
    }
    
    private func checkToggleOptions() {
        tableView.onToggleChanged = { [weak self] index, isOn in
            guard let self = self else { return }
            
            let randomIndexPath = IndexPath(row: Self.randomSongSettingNumber, section: 0)
            let loopingIndexPath = IndexPath(row: Self.loopingSettingNumber, section: 0)
            
            self.options[index].type = .toggle(isOn: isOn)
            
            if (index == Self.loopingSettingNumber && isOn){
                deactivateRandomIfLoopingActivated()
                self.tableView.tableView.reloadRows(at: [randomIndexPath], with: .none)
            } else if (index == Self.randomSongSettingNumber && isOn){
                deactivateLoopingIfRandomSongActivated()
                self.tableView.tableView.reloadRows(at: [loopingIndexPath], with: .none)
            }

        }
    }
    
    private func configureOptions(){
        guard options.isEmpty else { return }
        
        options = [
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
