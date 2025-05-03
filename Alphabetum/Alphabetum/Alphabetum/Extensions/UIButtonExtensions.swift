//
//  UIButtonExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

extension UIButton {
    func setSFImageAndTarget(systemName: String, configuration: UIImage.SymbolConfiguration, target: Any?, selector: Selector, tintColor: UIColor = .white){
        self.setImage(UIImage(systemName: systemName, withConfiguration: configuration), for: .normal)
        self.tintColor = tintColor
        setTarget(target: target, selector: selector)
    }
    
    func setTitleAndTarget(title: String, target: Any?, selector: Selector){
        self.setTitle(title, for: .normal)
        setTarget(target: target, selector: selector)
    }
    
    func setTarget(target: Any?, selector: Selector){
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
}
