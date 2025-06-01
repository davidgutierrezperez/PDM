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
        distanceLabel.text = lap.distance?.toString()
        durationLabel.text = lap.duration?.toString()
        paceLabel.text = lap.avaragePace.toString()
    }
    
    private func setupView(){
        addSubview(infoLapStack)
        
        configureInfoLapStack()
        
        NSLayoutConstraint.activate([
            infoLapStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            infoLapStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureInfoLapStack(){
        infoLapStack.axis = .horizontal
        infoLapStack.distribution = .equalCentering
        infoLapStack.spacing = 20
        infoLapStack.translatesAutoresizingMaskIntoConstraints = false
        
        infoLapStack.addArrangedSubview(indexLabel)
        infoLapStack.addArrangedSubview(durationLabel)
        infoLapStack.addArrangedSubview(distanceLabel)
        infoLapStack.addArrangedSubview(paceLabel)
    }

}
