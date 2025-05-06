//
//  CreateEntityViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 27/4/25.
//

import Foundation

/// Clase que gestiona la información relacionada con la creación de una entidad (Note o Folder)
final class CreateEntityViewModel {
    
    /// Nombre que tendrá la entidad nada mas ser creada.
    private(set) var text: String = ""
    
    /// Comprueba si el texto introducido es válido.
    var isValid: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Actualiza el texto introducido para crear la entidad.
    /// - Parameter newText: nuevo texto de la entidad.
    func updateText(_ newText: String){
        text = newText
    }
}
