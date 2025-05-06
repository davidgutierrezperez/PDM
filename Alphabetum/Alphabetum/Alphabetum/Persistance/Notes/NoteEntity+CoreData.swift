//
//  Note+cOREdATA.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import CoreData

/// Extensión que maneja la creación de una nota
/// a partir de información proveniente de CoreData.
extension Note {
    /// Constructor que pemite generar una nota a partir de la información
    /// almacenada en CoreData.
    /// - Parameter entity: entidad que representa una nota en CoreData.
    init(entity: NoteEntity){
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Sin título"
        self.creationDate = entity.creationDate ?? Date()
        self.lastModifiedSince = entity.lastModifiedSince ?? Date()
        
        if let data = entity.content,
           let attributedString = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as? NSMutableAttributedString {
            self.content = attributedString
        } else {
            self.content = NSMutableAttributedString(string: "")
        }
    }
    
    /// Genera una nota sin contenido alguno.
    /// - Parameter title: título de la nota.
    init(title: String){
        self.id = UUID()
        self.title = title
        self.creationDate = Date()
        self.lastModifiedSince = creationDate
        self.content = NSMutableAttributedString(string: "")
    }
}
