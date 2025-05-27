//
//  ActivityListCell.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class ActivityListCell: UITableViewCell {
    
    static let reuseIdentifier = "ActivityListCell"
    
    private let iconImage: UIImage
    private let distanceLabel = UILabel()
    private let durationLabel = UILabel()
    private let paceLabel = UILabel()
    private let locationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        iconImage = UIImage(systemName: SFSymbols.runner) ?? UIImage()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(activity: Activity){
        distanceLabel.text = String(activity.distance)
        durationLabel.text = activity.duration.toString()
        paceLabel.text = activity.avaragePace?.toString()
        locationLabel.text = activity.location
    }
    
    private func setupView(){
        contentView.addSubview(distanceLabel)
        
        backgroundColor = AppColors.cell
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            distanceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            distanceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

}
