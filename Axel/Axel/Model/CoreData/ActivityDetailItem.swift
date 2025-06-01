//
//  ActivityDetailItem.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import Foundation

struct ActivityDetailItem {
    let type: ActivityDetailType
    let value: String
    
    init(type: ActivityDetailType, value: String){
        self.type = type
        self.value = value
    }
}
