//
//  ViewController.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.primary
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }


}

