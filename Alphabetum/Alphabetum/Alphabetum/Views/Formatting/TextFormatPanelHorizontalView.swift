//
//  TextFormatPanelHorizontalView.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

class TextFormatPanelHorizontalView: UIView {

    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureButtons()
        configureStackView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtons(){}
    
    func configureStackView(){
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .equalCentering
    }
    
    func setupView(){
        addSubview(stackView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
}
