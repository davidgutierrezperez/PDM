//
//  ActivityDetailViewController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    
    private let viewModel: ActivityDetailViewModel
    private let activityDetailView = ActivityDetailView()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    
    private var lastOptionButtonPressed = ActivityDetailOptionButton(detail: .SUMMARY)
    
    init(id: UUID){
        ActivityDetailStore.shared.loadActivity(id: id)
        viewModel = ActivityDetailViewModel(id: id)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = activityDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .always

        showDetailView(activityDetailView.optionButtons.first!)

        configureTitleView()
        
        configurePageViewController()
        configureOptionsStackButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ActivityDetailStore.shared.clear()
    }
    
    @objc private func showDetailView(_ sender: ActivityDetailOptionButton){
        guard let id = viewModel.activity?.id else { return }
        
        if (sender.detailOption != lastOptionButtonPressed.detailOption){
            lastOptionButtonPressed.toggleUnderline()
        }
        
        sender.toggleUnderline()
        
        var detailVC = UIViewController()
        
        switch sender.detailOption {
        case .SUMMARY:
            break
        case .STATISTICS:
            detailVC = ActivityDetailStatisticsViewController(id: id)
            break
        case .LAPS:
            detailVC = ActivityDetailLapsViewController(id: id)
            break
        case .GRAPHICS:
            break
        }
        
        lastOptionButtonPressed = sender
        pageViewController.setViewControllers([detailVC], direction: .forward, animated: true)
    }
    
    private func configurePageViewController(){
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: activityDetailView.detailOptionsStack.bottomAnchor, constant: 16),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureOptionsStackButtons(){
        for button in activityDetailView.optionButtons {
            button.addTarget(self, action: #selector(showDetailView(_:)), for: .touchUpInside)
        }
    }
    
    private func configureTitleView(){
        var location = viewModel.activity?.location
        location! += " - " + (viewModel.activity?.date.formatted() ?? Date().formatted())
        
        title = location
    }
    
    
    
}
