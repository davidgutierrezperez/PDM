//
//  ActivityDetailView.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import UIKit

class ActivityDetailView: UIView {
    
    private let optionsDetail: [ActivityDetailOptions] = [.SUMMARY, .STATISTICS, .LAPS, .GRAPHICS]
    
    let detailOptionsStack = UIStackView()
    var optionButtons: [ActivityDetailOptionButton] = []
    
    private let headerContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        configureDetailStack()
        configureHeaderContainer()
        
        addSubview(headerContainer)
        
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            headerContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func configureHeaderContainer(){
        headerContainer.addSubview(detailOptionsStack)
        
        headerContainer.layer.borderColor = CGColor(gray: 0.5, alpha: 1)
        headerContainer.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            detailOptionsStack.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            detailOptionsStack.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            detailOptionsStack.leadingAnchor.constraint(greaterThanOrEqualTo: headerContainer.leadingAnchor, constant: 50),
            detailOptionsStack.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: 50)
        ])
    }
    
    private func configureDetailStack(){
        detailOptionsStack.axis = .horizontal
        detailOptionsStack.distribution = .equalSpacing
        detailOptionsStack.spacing = 20
        detailOptionsStack.translatesAutoresizingMaskIntoConstraints = false

        
        for option in optionsDetail {
            let button = ActivityDetailOptionButton(detail: option)
            button.setTitle(option.rawValue, for: .normal)
            
            optionButtons.append(button)
            detailOptionsStack.addArrangedSubview(button)
        }
    }
}
