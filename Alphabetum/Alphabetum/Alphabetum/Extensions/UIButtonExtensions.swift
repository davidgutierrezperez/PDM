//
//  UIButtonExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import UIKit

extension UIButton {
    func setSFImageAndTarget(systemName: String, configuration: UIImage.SymbolConfiguration, target: Any?, selector: Selector){
        self.setImage(UIImage(systemName: systemName, withConfiguration: configuration), for: .normal)
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
}
