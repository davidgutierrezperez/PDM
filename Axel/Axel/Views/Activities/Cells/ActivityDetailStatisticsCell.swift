//
//  ActivityDetailStatisticsCell.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import UIKit

class ActivityDetailStatisticsCell: UITableViewCell {
    
    static let reuseIdentifier = "ActivityDetailStatisticsCell"
    
    private let statisticsNameLabel = UILabel()
    private let statisticsValueLabel = UILabel()
    private let stackView = UIStackView()
    
    private static let fontSize: CGFloat = 21

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(detail: ActivityDetail){
        statisticsNameLabel.text = detail.type.rawValue
        statisticsValueLabel.text = detail.value
        
        configureLayer()
    }
    
    private func setupView(){
        configureLabels()
        configureStackView()
        
        contentView.addSubview(stackView)
        
        contentView.backgroundColor = AppColors.statistic
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

    }
    
    private func configureStackView(){
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(statisticsNameLabel)
        stackView.addArrangedSubview(statisticsValueLabel)
    }

    private func configureLabels(){
        statisticsNameLabel.font = UIFont.boldSystemFont(ofSize: ActivityDetailStatisticsCell.fontSize)
        statisticsNameLabel.textColor = .systemGray
        
        statisticsValueLabel.font = UIFont.systemFont(ofSize: ActivityDetailStatisticsCell.fontSize)
    }
    
    private func configureLayer(){
        guard let nameText = statisticsNameLabel.text else { return }
        
        if nameText.isEmpty {
            contentView.layer.borderWidth = 0
        }
    }
}
