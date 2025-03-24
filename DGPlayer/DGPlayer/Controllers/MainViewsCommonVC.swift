//
//  MainViewsCommonVC.swift
//  DGPlayer
//
//  Created by David Gutierrez on 23/3/25.
//

import UIKit

class MainViewsCommonVC: UIViewController {
    
    let scrollView = UIScrollView()
    var addButton = UIBarButtonItem()
    var enableSearchButton = UIBarButtonItem()
    var isSearchEnable: Bool = false
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton = configureAddButton()
        enableSearchButton = configureSearchButton()
    }
    
    func configureAddButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.tintColor = .systemRed
        
        return addButton
    }
    
    func configureSearchButton() -> UIBarButtonItem {
        let enableSearchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        enableSearchButton.tintColor = .systemRed
        
        return enableSearchButton
    }
    
    func addTargetToButton(boton: UIBarButtonItem, target: AnyObject?, action: Selector) {
        boton.target = target
        boton.action = action
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
