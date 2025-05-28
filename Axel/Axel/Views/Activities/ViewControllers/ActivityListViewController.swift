//
//  ActivityListViewController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class ActivityListViewController: ViewController {
    
    private let viewModel = ActivityListViewModel.shared
    private let activityListView = ActivityListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        
        self.view = activityListView
    }
    
    private func configureNavigationController(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Mis actividades"
        tabBarItem.title = "Home"
    }
    
    private func configureTableView(){
        activityListView.tableView.register(ActivityListCell.self, forCellReuseIdentifier: ActivityListCell.reuseIdentifier)
        activityListView.tableView.delegate = self
        activityListView.tableView.dataSource = self
        activityListView.tableView.backgroundColor = AppColors.primary
        
        viewModel.fetch()
    }
    
}

extension ActivityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityListCell.reuseIdentifier, for: indexPath) as! ActivityListCell
        
        guard let activity = viewModel.at(indexPath.row) else { return UITableViewCell() }
        cell.configure(activity: activity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let activity = viewModel.at(indexPath.row) else { return }
        
        let activityDetailVC = ActivityDetailViewController(id: activity.id)
        
        navigationController?.pushViewController(activityDetailVC, animated: true)
    }
    
    
    
    
}
