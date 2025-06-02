//
//  LiveActivityViewController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class LiveActivityViewController: UIViewController {
    
    private let liveActivityView = LiveActivityView()
    
    override func loadView() {
        self.view = liveActivityView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationController?.tabBarController?.isTabBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
