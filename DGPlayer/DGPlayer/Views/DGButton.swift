//
//  DGButton.swift
//  DGPlayer
//
//  Created by David Gutierrez on 13/3/25.
//

import UIKit

class DGButton: UIButton {

    private var symbol: UIImage!
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSymbol(image: UIImage){
        symbol = image
    }
    
    private func configure(){
        
    }

}
