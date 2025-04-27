//
//  Note+cOREdATA.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

extension Note {
    init(entity: NoteEntity){
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        self.creationDate = entity.creationDate ?? Date()
        self.lastModifiedSince = entity.lastModifiedSince ?? Date()
        
        if let data = entity.content,
           let attributedString = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSMutableAttributedString {
            self.content = attributedString
        } else {
            self.content = NSMutableAttributedString(string: "")
        }
    }
}
