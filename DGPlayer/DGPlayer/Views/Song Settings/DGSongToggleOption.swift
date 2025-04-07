//
//  DGSongOption.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

class DGSongToggleOption: UITableViewCell {
    
    static let reusableIdentifier = "DGSongOption"
        
    var titleLabel = UILabel()
    var toggleSwitch = UISwitch()
    var isOptionEnabled: Bool = false
    let songSetting: SongSetting = .Looping
    
    var switchAction: ((Bool) -> Void)?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        configureToggleSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel(title: String){
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureToggleSwitch(){
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.onTintColor = .systemGreen
        
        toggleSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    
    @objc private func switchChanged(_ sender: UISwitch){
        isOptionEnabled = sender.isOn
        switchAction?(sender.isOn)
    }
    
    func configure(text: String, isEnabled: Bool){
        configureLabel(title: text)
        isOptionEnabled = isEnabled
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        
        toggleSwitch.removeTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        toggleSwitch.isOn = isEnabled
        toggleSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                        
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
