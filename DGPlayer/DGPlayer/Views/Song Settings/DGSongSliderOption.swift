//
//  DGSongSliderOption.swift
//  DGPlayer
//
//  Created by David Gutierrez on 6/4/25.
//

import UIKit

class DGSongSliderOption: UITableViewCell {
    
    static let reusableIdentifier = "SliderCell"
    let titleCell = UILabel()
    let slider = UISlider()
    
    var onValueChanged: ((Float) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DGSongSliderOption.reusableIdentifier)
        
        setupView()
        configureSlider(min: 0, max: 1, current: 0.5, isEnabled: true)
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        configure(title: "", min: 0, max: 1, current: 0.5, isEnabled: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSlider(min: Float, max: Float, current: Float, isEnabled: Bool){
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = current
        slider.isEnabled = isEnabled
    }
    
    private func configureTitleCell(title: String){
        titleCell.text = title
        titleCell.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    func configure(title: String, min: Float, max: Float, current: Float, isEnabled: Bool){
        configureTitleCell(title: title)
        configureSlider(min: min, max: max, current: current, isEnabled: isEnabled)
    }
    
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
    
    @objc private func sliderChanged(){
        onValueChanged?(slider.value)
    }

}
