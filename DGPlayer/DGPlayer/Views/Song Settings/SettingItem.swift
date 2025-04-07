//
//  SettingItem.swift
//  DGPlayer
//
//  Created by David Gutierrez on 6/4/25.
//

import Foundation

enum SettingID {
    case looping
    case randomSong
    case enableRate
    case volume
    case rate
}

enum SettingType {
    case slider(min: Float, max: Float, current: Float, isEnabled: Bool)
    case toggle(isOn: Bool)
}

struct SettingItem {
    let id: SettingID
    let title: String
    var type: SettingType
}
