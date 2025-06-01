//
//  ActivityDetailStatisticsViewController.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import UIKit

class ActivityDetailStatisticsViewController: UIViewController {
    
    private let viewModel: ActivityDetailViewModel
    private let activityDetailStatisticsView = ActivityDetailStatisticsView()
    
    init(id: UUID){
        viewModel = ActivityDetailViewModel(id: id)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = activityDetailStatisticsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView(){
        activityDetailStatisticsView.tableView.register(ActivityDetailStatisticsCell.self, forCellReuseIdentifier: ActivityDetailStatisticsCell.reuseIdentifier)
        activityDetailStatisticsView.tableView.dataSource = self
        activityDetailStatisticsView.tableView.delegate = self
        activityDetailStatisticsView.tableView.backgroundColor = AppColors.primary
    }

    
}

extension ActivityDetailStatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityDetailStatisticsCell.reuseIdentifier, for: indexPath) as! ActivityDetailStatisticsCell
        
        cell.configure(detail: viewModel.details[indexPath.row])
        
        return cell
    }
    
    
}
