//
//  ActivityDetailSummaryView.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import UIKit

class ActivityDetailSummaryView: UIView {

    private let locationLabel = UILabel()
    private let dateStackView = UIStackView()
    private let distanceStackView = ActivityDetailVerticalStackView(valueSize: 48)
    private let avaragePaceStackView = ActivityDetailVerticalStackView()
    private let durationStackView = ActivityDetailVerticalStackView()
    
    private let summaryVerticalStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(activity: Activity?){
        guard let activity = activity else { return }
        
        locationLabel.text = activity.location
        locationLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        distanceStackView.configure(value: FormatHelper.formatDistance(activity.distance), title: "Distancia")
        avaragePaceStackView.configure(value: activity.avaragePace!.toString(), title: "Ritmo medio")
        durationStackView.configure(value: FormatHelper.formatTime(activity.duration), title: "Tiempo total")
        configureDateStack(activity: activity)
    }
    
    private func setupView(){
        addSubview(summaryVerticalStack)
        
        configureSummaryStack()
        
        NSLayoutConstraint.activate([
            summaryVerticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            summaryVerticalStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureSummaryStack(){
        summaryVerticalStack.axis = .vertical
        summaryVerticalStack.distribution = .equalCentering
        summaryVerticalStack.spacing = 20
        
        summaryVerticalStack.addArrangedSubview(dateStackView)
        summaryVerticalStack.addArrangedSubview(locationLabel)
        summaryVerticalStack.addArrangedSubview(distanceStackView)
        summaryVerticalStack.addArrangedSubview(UIStackView.createHorizontalFromTwoStacks(avaragePaceStackView, durationStackView))
        
        summaryVerticalStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDateStack(activity: Activity){
        let image = UIImageView(image: UIImage(systemName: SFSymbols.runner))
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        
        let date = UILabel()
        date.text = activity.date.formatted()
        
        dateStackView.axis = .horizontal
        dateStackView.distribution = .equalSpacing

        dateStackView.addArrangedSubview(image)
        dateStackView.addArrangedSubview(date)
    }

    
}
