//
//  ActivityDetailItem.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import Foundation

/// Modelo que representa el tipo de información a mostrar
/// de una actividad y su valor.
struct ActivityDetailItem {
    let type: ActivityDetailType
    let value: String
    
    init(type: ActivityDetailType, value: String){
        self.type = type
        self.value = value
    }
}
