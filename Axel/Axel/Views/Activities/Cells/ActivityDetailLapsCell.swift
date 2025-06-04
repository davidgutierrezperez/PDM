//
//  ActivityDetailLapsCell.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import UIKit

class ActivityDetailLapsCell: UITableViewCell {

    static let reuseIdentifier = "ActivityDetailLapsCell"
    
    private let indexLabel = UILabel()
    private let distanceLabel = UILabel()
    private let durationLabel = UILabel()
    private let paceLabel = UILabel()
    
    private let infoLapStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(lap: Lap){
        indexLabel.text = String(lap.index)
        distanceLabel.text = FormatHelper.formatDistance(lap.distance ?? 0.0)
        durationLabel.text = FormatHelper.formatTime(lap.duration ?? 0.0)
        paceLabel.text = FormatHelper.formatTime(lap.avaragePace)
    }
    
    private func setupView(){
        addSubview(infoLapStack)
        
        configureInfoLapStack()
        
        NSLayoutConstraint.activate([
            infoLapStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoLapStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoLapStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoLapStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func configureInfoLapStack(){
        infoLapStack.axis = .horizontal
        infoLapStack.distribution = .fillEqually
        infoLapStack.alignment = .center
        infoLapStack.spacing = 50
        infoLapStack.translatesAutoresizingMaskIntoConstraints = false
        
        infoLapStack.addArrangedSubview(indexLabel)
        infoLapStack.addArrangedSubview(durationLabel)
        infoLapStack.addArrangedSubview(distanceLabel)
        infoLapStack.addArrangedSubview(paceLabel)
    }

}
