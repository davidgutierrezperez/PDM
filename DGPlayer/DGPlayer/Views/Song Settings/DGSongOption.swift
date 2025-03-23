//
//  DGSongOption.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

class DGSongOption: UITableViewCell {
    
    static let reusableIdentifier = "DGSongOption"
        
    var label = UILabel()
    var toggleSwitch = UISwitch()
    var isOptionEnabled: Bool = false
    let songSetting: SongSetting = .Looping
    
    var switchAction: ((Bool) -> Void)?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        configureLabels()
        configureToggleSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabels(){
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.text = text
        isOptionEnabled = isEnabled
        
        contentView.addSubview(label)
        contentView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                        
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .systemBackground
    }

}
