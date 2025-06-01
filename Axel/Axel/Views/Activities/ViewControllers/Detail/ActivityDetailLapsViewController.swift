//
//  ActivityDetailLapsViewController.swift
//  Axel
//
//  Created by David Gutierrez on 29/5/25.
//

import UIKit

class ActivityDetailLapsViewController: UIViewController {

    private let viewModel: ActivityDetailViewModel
    private let activityDetailLapsView = ActivityDetailLapsView()
    
    init(id: UUID){
        viewModel = ActivityDetailViewModel(id: id)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = activityDetailLapsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureTableView()
    }
    
    private func configureTableView(){
        activityDetailLapsView.tableView.register(ActivityDetailLapsCell.self, forCellReuseIdentifier: ActivityDetailLapsCell.reuseIdentifier)
        activityDetailLapsView.tableView.dataSource = self
        activityDetailLapsView.tableView.delegate = self
    }
    
}

extension ActivityDetailLapsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activity?.laps.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityDetailLapsCell.reuseIdentifier, for: indexPath) as! ActivityDetailLapsCell
        
        let lap = viewModel.activity?.laps[indexPath.row] ?? Lap()
        cell.configure(lap: lap)
        
        return cell
    }
    
    
}
