//
//  LiveActivityView.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import UIKit

class LiveActivityView: UIStackView {

    let playPauseButton = UIButton()
    let saveActivityButton = UIButton()
    
    private let distanceStack = ActivityDetailVerticalStackView(alignment: .center, largeValue: true)
    private let durationStack = ActivityDetailVerticalStackView(alignment: .center, largeValue: true)
    private let paceStack = ActivityDetailVerticalStackView(alignment: .center, largeValue: true)
    
    private let infoActivityStack = UIStackView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValues(distance: Double, duration: TimeInterval, pace: Double){
        distanceStack.updateValue(newValue: FormatHelper.formatDistance(distance))
        durationStack.updateValue(newValue: duration.formatted())
        paceStack.updateValue(newValue: pace.formatted())
    }
    
    private func setupView(){
        initialConfiguration()
        
        addSubview(infoActivityStack)
        configureInfoActivityStack()
        
        NSLayoutConstraint.activate([
            infoActivityStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            infoActivityStack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func configureInfoActivityStack(){
        infoActivityStack.axis = .vertical
        infoActivityStack.distribution = .equalSpacing
        infoActivityStack.spacing = 50
        
        infoActivityStack.addArrangedSubview(distanceStack)
        infoActivityStack.addArrangedSubview(durationStack)
        infoActivityStack.addArrangedSubview(paceStack)
        infoActivityStack.addArrangedSubview(playPauseButton)
        
        infoActivityStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initialConfiguration(){
        distanceStack.configure(value: FormatHelper.formatDistance(0), title: "Distance")
        durationStack.configure(value: "0:00", title: "Duration")
        paceStack.configure(value: "0:00 min/km", title: "Pace")
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 150)
        playPauseButton.setImage(UIImage(systemName: SFSymbols.play, withConfiguration: configuration), for: .normal)
    }
}
