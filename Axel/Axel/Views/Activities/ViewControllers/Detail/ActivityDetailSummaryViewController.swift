//
//  ActivityDetailSummaryViewController.swift
//  Axel
//
//  Created by David Gutierrez on 29/5/25.
//

import UIKit

class ActivityDetailSummaryViewController: UIViewController {
    
    private let activityDetailSummaryView = ActivityDetailSummaryView()
    private let viewModel: ActivityDetailViewModel
    
    init(id: UUID){
        viewModel = ActivityDetailViewModel(id: id)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = activityDetailSummaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityDetailSummaryView.configure(activity: viewModel.activity)

        let routeMapManager = RouteMapManager(activity: viewModel.activity!, mapView: activityDetailSummaryView.mapView)
        
        routeMapManager.renderRoute()
    }
    


}
