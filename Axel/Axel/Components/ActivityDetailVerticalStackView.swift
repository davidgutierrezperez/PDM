//
//  ActivityDetailVerticalStackView.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import UIKit

class ActivityDetailVerticalStackView: UIStackView {
    
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()
    
    private var valueSize:CGFloat = 24
    
    init(valueSize: CGFloat = 24, alignment: UIStackView.Alignment = .leading, largeValue: Bool = false){
        self.valueSize = valueSize
        
        super.init(frame: CGRect())
        
        axis = .vertical
        distribution = .equalCentering
        spacing = 10
        
        self.alignment = alignment
        
        if (largeValue){
            self.valueSize = 48
        }
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(value: String, title: String){
        valueLabel.text = value
        titleLabel.text = title
    }
    
    func updateValue(newValue: String){
        valueLabel.text = newValue
    }
    
    private func setupView(){
        addArrangedSubview(valueLabel)
        addArrangedSubview(titleLabel)
        
        configureLabels()
    }
    
    private func configureLabels(){
        valueLabel.font = UIFont.boldSystemFont(ofSize: valueSize)
        titleLabel.textColor = AppColors.statisticOptionLabel
    }

}
