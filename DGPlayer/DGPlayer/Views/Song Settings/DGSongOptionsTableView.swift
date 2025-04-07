//
//  DGSongOptionsTableView.swift
//  DGPlayer
//
//  Created by David Gutierrez on 19/3/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class DGSongOptionsTableView: UITableViewController {
    
    var toggleOptions: [SettingItem] = []
    var sliderOptions: [SettingItem] = []
    
    var onToggleChanged: ((Int, Bool) -> Void)?
    var onSliderChanged: ((Int, Float) -> Void)?
    
    init(options: [SettingItem]){
        super.init(style: .plain)
        
        for option in options {
            switch option.type {
            case .toggle:
                toggleOptions.append(option)
                break
            case .slider:
                sliderOptions.append(option)
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DGSongToggleOption.self, forCellReuseIdentifier: DGSongToggleOption.reusableIdentifier)
        tableView.register(DGSongSliderOption.self, forCellReuseIdentifier: DGSongSliderOption.reusableIdentifier)
        
        tableView.separatorStyle = .none
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? toggleOptions.count : sliderOptions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = (indexPath.section == 0) ? toggleOptions[indexPath.row] : sliderOptions[indexPath.row]

        switch setting.type {
        case .toggle(let isOn):
            let cell = tableView.dequeueReusableCell(withIdentifier: DGSongToggleOption.reusableIdentifier, for: indexPath) as! DGSongToggleOption
            cell.configure(text: setting.title, isEnabled: isOn)
            
            cell.switchAction = { [weak self] newValue in
                self?.onToggleChanged?(indexPath.row, newValue)
                
            }
            
            return cell

        case .slider(let min, let max, let current):
            let cell = tableView.dequeueReusableCell(withIdentifier: DGSongSliderOption.reusableIdentifier, for: indexPath) as! DGSongSliderOption
            cell.configure(title: setting.title, min: min, max: max, current: current)
            
            cell.onValueChanged = { [weak self] newValue in
                print("NewValue: ", newValue)
                self?.onSliderChanged?(indexPath.row, newValue)
                
            }
            
            return cell
        }
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
