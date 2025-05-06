//
//  TextFormattingViewModel.swift
//  Alphabetum
//
//  Created by David Gutierrez on 2/5/25.
//

import Foundation

/// Clase qeu gestiona la información relacionada con los formatos
/// del texto de una nota.
final class TextFormattingViewModel {
    /// Conjunto de formatos activos en el texto de una nota.
    private(set) var activeFormats: Set<TextFormat> = []
    
    /// Actualiza el conjunto de formatos activos en el texto de una nota.
    /// - Parameter formats: set con el conjunto de formatos que se encuentran activos.
    func updateActiveFormats(_ formats: Set<TextFormat>){
        activeFormats = formats
    }
    
    /// Actualiza el estado de un formato en el texto.
    /// - Parameter format: formato cuyo estado será actualizado.
    func toggle(_ format: TextFormat){
        if activeFormats.contains(format){
            activeFormats.remove(format)
        } else {
            activeFormats.insert(format)
        }
    }
    
    /// Indica si un formato está activo en el texto de una nota.
    /// - Parameter format: formato a comprobar.
    /// - Returns: un boolano con valor de **True** si el formato
    /// está activo y **False** en caso contrario.
    func isActive(_ format: TextFormat) -> Bool {
        return activeFormats.contains(format)
    }
}
