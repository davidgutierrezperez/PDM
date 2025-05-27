//
//  ActivityListViewController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class ActivityListViewController: ViewController {
    
    private let tableView = UITableView()
    private let viewModel = ActivityListViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func configureNavigationController(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Mis actividades"
        tabBarItem.title = "Home"
    }
    
    private func configureTableView(){
        tableView.register(ActivityListCell.self, forCellReuseIdentifier: ActivityListCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = AppColors.primary
        
        viewModel.fetch()
    }
    
    private func setupView() {
        configureNavigationController()
        configureTableView()
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
