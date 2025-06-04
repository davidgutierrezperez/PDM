//
//  ActivityListCell.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class ActivityListCell: UITableViewCell {
    
    static let reuseIdentifier = "ActivityListCell"
    
    private let iconImage = UIImageView()
    private let distanceLabel = UILabel()
    private let durationLabel = UILabel()
    private let paceLabel = UILabel()
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let locationDateStackView = UIStackView()
    private let timeStackView = UIStackView()
    private let paceStackView = UIStackView()
    private let bottomStatsStackView = UIStackView()
    
    private let verticalStackView = UIStackView()
    
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        iconImage.image = UIImage(systemName: SFSymbols.runner) ?? UIImage()
        iconImage.tintColor = .black
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(activity: Activity){
        distanceLabel.text = FormatHelper.formatDistance(activity.distance)
        durationLabel.text = FormatHelper.formatTime(activity.duration)
        paceLabel.text = FormatHelper.formatPace(activity.avaragePace!)
        locationLabel.text = activity.location
        dateLabel.text = activity.date.formatted()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    private func setupView(){
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        configureDistanceLabel()
        configureLocationDateStack()
        configureTimeStack()
        configurePaceStack()
        configureBottomStack()
        configureVerticalStack()
        configureContainerView()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

    }
    
    private func configureDistanceLabel(){
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.font = UIFont.systemFont(ofSize: 25)
    }
    
    private func configureLocationDateStack(){
        locationDateStackView.axis = .horizontal
        locationDateStackView.translatesAutoresizingMaskIntoConstraints = false
        locationDateStackView.distribution = .fillProportionally
        
        locationLabel.textColor = .black
        
        locationDateStackView.addArrangedSubview(iconImage)
        locationDateStackView.addArrangedSubview(locationLabel)
        locationDateStackView.addArrangedSubview(dateLabel)
    }
    
    private func configureTimeStack(){
        timeStackView.axis = .vertical
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let durationTitleLabel = UILabel()
        durationTitleLabel.textColor = .black
        durationTitleLabel.font = UIFont.boldSystemFont(ofSize: durationTitleLabel.font.pointSize)
        durationTitleLabel.text = "TIEM."
        
        timeStackView.addArrangedSubview(durationTitleLabel)
        timeStackView.addArrangedSubview(durationLabel)
    }
    
    private func configurePaceStack(){
        paceStackView.axis = .vertical
        paceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let paceTitleLabel = UILabel()
        paceTitleLabel.textColor = .black
        paceTitleLabel.font = UIFont.boldSystemFont(ofSize: paceTitleLabel.font.pointSize)
        paceTitleLabel.text = "RITMO"
        
        paceStackView.addArrangedSubview(paceTitleLabel)
        paceStackView.addArrangedSubview(paceLabel)
    }
    
    private func configureBottomStack(){
        bottomStatsStackView.axis = .horizontal
        bottomStatsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStatsStackView.distribution = .fillProportionally
        
        bottomStatsStackView.addArrangedSubview(distanceLabel)
        bottomStatsStackView.addArrangedSubview(timeStackView)
        bottomStatsStackView.addArrangedSubview(paceStackView)
    }
    
    private func configureVerticalStack(){
        verticalStackView.backgroundColor = AppColors.cell
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.layer.cornerRadius = 10
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        verticalStackView.layoutMargins = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.addArrangedSubview(locationDateStackView)
        verticalStackView.addArrangedSubview(bottomStatsStackView)
        
        containerView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6)
        ])
    }
    
    private func configureContainerView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
    }

}
