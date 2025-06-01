//
//  ActivityDetailLapsView.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import UIKit

class ActivityDetailLapsView: UIView {
    
    private let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
    
    private let infoHeaderStack = UIStackView()
    private let infoHeaders: [ActivityDetailLapsInfoHeader] = [.index, .duration, .distance, .pace]
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        configureInfoHeaderStack()
        configureHeaderContainer()
        
        addSubview(headerContainer)
        addSubview(tableView)
        
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 80),
            
            tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
         
    }
    
    private func configureHeaderContainer(){
        headerContainer.addSubview(infoHeaderStack)
        headerContainer.backgroundColor = .systemGray5

        NSLayoutConstraint.activate([
            infoHeaderStack.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            infoHeaderStack.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            infoHeaderStack.leadingAnchor.constraint(greaterThanOrEqualTo: headerContainer.leadingAnchor, constant: 16),
            infoHeaderStack.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureInfoHeaderStack(){
        infoHeaderStack.axis = .horizontal
        infoHeaderStack.distribution = .equalCentering
        infoHeaderStack.spacing = 20
        infoHeaderStack.translatesAutoresizingMaskIntoConstraints = false
        infoHeaderStack.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        
        for header in infoHeaders {
            let headerLabel = UILabel()
            headerLabel.font = UIFont.boldSystemFont(ofSize: headerLabel.font.pointSize)
            headerLabel.text = header.rawValue
            
            infoHeaderStack.addArrangedSubview(headerLabel)
        }
    }

}
