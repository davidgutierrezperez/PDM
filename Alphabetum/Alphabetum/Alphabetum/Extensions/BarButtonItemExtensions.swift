//
//  BarButtonItemExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 5/5/25.
//

import UIKit

extension UIBarButtonItem {
    func configureButton(systemName: String, selector: Selector, target: AnyObject?){
        self.title = nil
        self.image = UIImage(systemName: systemName)
        self.style = .plain
        self.action = selector
        self.target = target
        self.tintColor = .systemYellow
    }
    
    func configureButton(title: String, selector: Selector, target: AnyObject?){
        self.image = nil
        self.title = title
        self.style = .plain
        self.action = selector
        self.target = target
        self.tintColor = .systemYellow
    }
}
