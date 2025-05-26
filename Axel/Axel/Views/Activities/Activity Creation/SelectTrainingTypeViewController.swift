//
//  SelectTrainingTypeViewController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class SelectTrainingTypeViewController: UITableViewController {
    
    private let trainingTypes: [TrainingType] = [.FREE_RUN, .DISTANCE_INTERVAL, .TIME_INTERVAL]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.primary
        
        tableView.register(TrainingTypeCell.self, forCellReuseIdentifier: TrainingTypeCell.reuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trainingTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrainingTypeCell.reuseIdentifier, for: indexPath) as! TrainingTypeCell

        let type = trainingTypes[indexPath.row]
        cell.configure(type: type)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = trainingTypes[indexPath.row]
        
        if type == .FREE_RUN {
            navigationController?.pushViewController(LiveActivityViewController(), animated: true)
        }
    }
    

}
