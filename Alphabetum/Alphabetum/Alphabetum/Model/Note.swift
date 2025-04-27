//
//  Note.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

struct Note {
    let id: UUID
    var content: NSMutableAttributedString
    var title: String
    var lastModifiedSince: Date
    var creationDate: Date
}
