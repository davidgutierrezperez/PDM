//
//  SettingItem.swift
//  DGPlayer
//
//  Created by David Gutierrez on 6/4/25.
//

import Foundation

/// Enumerado que represnta los distintos
/// tipos de configuración.
enum SettingID {
    case looping
    case randomSong
    case enableRate
    case volume
    case rate
}

/// Enumerado que indica las diferentes
/// formas en las que se puede representar una configuración.
enum SettingType {
    case slider(min: Float, max: Float, current: Float, isEnabled: Bool)
    case toggle(isOn: Bool)
}

/// Objecto que representa una configuración.
struct SettingItem {
    let id: SettingID
    let title: String
    var type: SettingType
}
