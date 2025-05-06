//
//  Folder.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

/// Estructura que representa una Carpeta
struct Folder {
    let id: UUID
    let title: String
    let notes: [Note]
}
