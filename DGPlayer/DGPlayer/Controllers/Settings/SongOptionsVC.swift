//
//  SongOptionsVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

class SongOptionsVC: UIViewController {
    
    var tableView : DGSongOptionsTableView!
    var options: [DGSongOption] = []
    
    static let loopingSettingNumber:Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureOptions()
        tableView = DGSongOptionsTableView(options: options)
        configure()
    }
    
    private func configureOptions(){
        let loopingSetting = DGSongOption()
        
        loopingSetting.configure(text: "Loop", isEnabled: false)
        
        options.append(loopingSetting)
    }

    
    private func configure(){
        tableView.tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView.tableView)
                
        NSLayoutConstraint.activate([
            tableView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
