//
//  LiveActivityViewController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class LiveActivityViewController: UIViewController {
    
    private let liveActivityView = LiveActivityView()
    private let viewModel: LiveActivityViewModel
    
    init(){
        viewModel = LiveActivityViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = liveActivityView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationController?.tabBarController?.isTabBarHidden = true
        
        setupTimerBinding()
        setupButtonActions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func togglePlayPauseButton(){
        liveActivityView.togglePlayPauseButton()
        
        switch (viewModel.status){
        case .NOT_INTIATED:
            viewModel.startActivity()
            break
        case .ACTIVE:
            viewModel.pauseActivity()
            liveActivityView.toggleEnablingSaveAndDiscardButtons()
            break
        case .PAUSED:
            viewModel.resumeActivity()
            liveActivityView.toggleEnablingSaveAndDiscardButtons()
            break
        default:
            viewModel.pauseActivity()
            break
        }
    }
    
    @objc private func stopActivityAndSave(_ sender: UIButton){
        let alert = AlertControllerFactory.makeCancelConfirmAndRedirectAlert(message: "¿Desea guardar la actividad", view: ActivityListViewController(), navigationController: navigationController!, onConfirm: {
            self.viewModel.endActivity()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func discardActivity(_ sender: UIButton){
        let alert = AlertControllerFactory.makeCancelConfirmAndRedirectAlert(message: "¿Desea descartar la actividad", view: ActivityListViewController(), navigationController: navigationController!, onConfirm: {})
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupTimerBinding(){
    
        
        viewModel.onTimerUpdate = { [weak self] duration in
            guard let self = self,
                  let activity = viewModel.activity else { return }
            
            DispatchQueue.main.async {
                self.liveActivityView.updateValues(distance: activity.distance, duration: duration, pace: self.viewModel.currentPace)
            }
        }
    }
    
    private func setupButtonActions(){
        liveActivityView.playPauseButton.addTarget(self, action: #selector(togglePlayPauseButton), for: .touchUpInside)
        liveActivityView.saveActivityButton.addTarget(self, action: #selector(stopActivityAndSave(_:)), for: .touchUpInside)
        liveActivityView.discardActivityButton.addTarget(self, action: #selector(discardActivity(_:)), for: .touchUpInside)
    }
    

}

