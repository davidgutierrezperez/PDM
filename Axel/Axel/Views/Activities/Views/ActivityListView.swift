//
//  ActivityListView.swift
//  Axel
//
//  Created by David Gutierrez on 27/5/25.
//

import UIKit

class ActivityListView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
    private func setupView(){
        addSubview(tableView)
        
        backgroundColor = AppColors.primary
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 120
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
