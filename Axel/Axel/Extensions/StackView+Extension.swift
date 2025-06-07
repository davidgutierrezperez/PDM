//
//  StackView+Extension.swift
//  Axel
//
//  Created by David Gutierrez on 2/6/25.
//

import UIKit

/// Extensiones del componente UIStackView()
extension UIStackView {
    /// Permite crear un UIStackView() horizontal formado por otros dos UIStackView() apilados.
    /// - Parameters:
    ///   - first: primer UIStackView() a apilar.
    ///   - second: segundo UIStackView() a apilar.
    /// - Returns: UIStackView() personalizado.
    static func createHorizontalFromTwoStacks(_ first: UIStackView, _ second: UIStackView) -> UIStackView {
        let horizontalStack = UIStackView()
        
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .equalCentering
        horizontalStack.spacing = 20
        
        horizontalStack.addArrangedSubview(first)
        horizontalStack.addArrangedSubview(second)
        
        return horizontalStack
    }
}
