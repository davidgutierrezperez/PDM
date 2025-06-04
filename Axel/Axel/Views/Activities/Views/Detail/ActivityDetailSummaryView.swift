//
//  ActivityDetailSummaryView.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import UIKit
import MapKit

class ActivityDetailSummaryView: UIView {

    let mapView = MKMapView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        avaragePaceStackView.configure(value: FormatHelper.formatPace(activity.avaragePace!, showUnit: true), title: "Ritmo medio")
        durationStackView.configure(value: FormatHelper.formatTime(activity.duration), title: "Tiempo total")
        configureDateStack(activity: activity)
    }
    
    private func setupView(){
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(summaryVerticalStack)
        
        configureSummaryStack()
        
        NSLayoutConstraint.activate([
            // scrollView llena la vista
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // contentView igual ancho que scrollView y altura flexible
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // stack dentro del contentView
            summaryVerticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            summaryVerticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            summaryVerticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            summaryVerticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureSummaryStack(){
        summaryVerticalStack.axis = .vertical
        summaryVerticalStack.distribution = .fillProportionally
        summaryVerticalStack.spacing = 20
        
        mapView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        mapView.translatesAutoresizingMaskIntoConstraints = false

        summaryVerticalStack.addArrangedSubview(dateStackView)
        summaryVerticalStack.addArrangedSubview(mapView)
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
