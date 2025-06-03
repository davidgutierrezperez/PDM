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
    let discardActivityButton = UIButton()
    
    private var isPlayButton: Bool = true
    
    private let distanceStack = ActivityDetailVerticalStackView(alignment: .center, largeValue: true)
    private let durationStack = ActivityDetailVerticalStackView(alignment: .center, largeValue: true)
    private let paceStack = ActivityDetailVerticalStackView(alignment: .center, largeValue: true)
    private let saveAndDiscardStack = UIStackView()
    
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
        durationStack.updateValue(newValue: FormatHelper.formatTime(duration))
        paceStack.updateValue(newValue: FormatHelper.formatTime(pace))
    }

    func togglePlayPauseButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 150)
        let image = (isPlayButton) ? UIImage(systemName: SFSymbols.pause, withConfiguration: configuration)
                                    : UIImage(systemName: SFSymbols.play, withConfiguration: configuration)
        
        playPauseButton.setImage(image, for: .normal)
        isPlayButton.toggle()
    }
    
    func toggleEnablingSaveAndDiscardButtons(){
        saveActivityButton.isEnabled.toggle()
        discardActivityButton.isEnabled.toggle()
    }
    
    private func setupView(){
        setupButtons()
        setupSaveAndDiscardStack()
        
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
        infoActivityStack.addArrangedSubview(saveAndDiscardStack)
        
        infoActivityStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSaveAndDiscardStack(){
        saveAndDiscardStack.axis = .horizontal
        saveAndDiscardStack.distribution = .equalCentering
        saveAndDiscardStack.spacing = 20
        
        saveAndDiscardStack.addArrangedSubview(saveActivityButton)
        saveAndDiscardStack.addArrangedSubview(discardActivityButton)
    }
    
    private func setupButtons(){
        distanceStack.configure(value: FormatHelper.formatDistance(0), title: "Distance")
        durationStack.configure(value: "0:00", title: "Duration")
        paceStack.configure(value: "0:00", title: "Pace")
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 150)
        playPauseButton.setImage(UIImage(systemName: SFSymbols.play, withConfiguration: configuration), for: .normal)
        
        saveActivityButton.setImage(UIImage(systemName: SFSymbols.save, withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        saveActivityButton.isEnabled = false
        saveActivityButton.tintColor = .white
        
        discardActivityButton.setImage(UIImage(systemName: SFSymbols.trash, withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        discardActivityButton.isEnabled = false
        discardActivityButton.tintColor = .red
    }
}
