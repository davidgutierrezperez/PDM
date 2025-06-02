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
            break
        case .PAUSED:
            viewModel.resumeActivity()
            break
        default:
            viewModel.pauseActivity()
            break
        }
    }
    
    @objc private func stopActivityAndSave(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: "¿Desea guardar la actividad?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: {_ in
            self.viewModel.endActivity()
            
            let activityListVC = ActivityListViewController()
            self.navigationController?.setViewControllers([activityListVC], animated: true)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupButtonActions(){
        liveActivityView.playPauseButton.addTarget(self, action: #selector(togglePlayPauseButton), for: .touchUpInside)
        liveActivityView.saveActivityButton.addTarget(self, action: #selector(stopActivityAndSave(_:)), for: .touchUpInside)
    }
    

}
