//
//  SettingItem.swift
//  DGPlayer
//
//  Created by David Gutierrez on 6/4/25.
//

import Foundation

enum SettingType {
    case slider(current: Float)
    case toggle(isOn: Bool)
}

struct SettingItem {
    let title: String
    var type: SettingType
}
