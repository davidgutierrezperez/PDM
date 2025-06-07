//
//  FormatHelper.swift
//  Axel
//
//  Created by David Gutierrez on 28/5/25.
//

import Foundation

/// Clase que gestiona operaciones auxilares relacionadas con el formato
/// de diferentes tipos de datos
final class FormatHelper {
    /// Premite obtener un String a partir de una distancia en tipo de dato Double.
    /// - Parameter distance: distancia.
    /// - Returns: un String con el valor de la distancia.
    public static func formatDistance(_ distance: Double) -> String {
        let kilometers = distance / 1000
        return String(format: "%.2f km", kilometers)
    }
    
    /// Permite obtener un String con el tiempo de un intervalo.
    /// - Parameter time: intervalo de tiempo.
    /// - Returns: cadena de caracteres con el valor de un intervalo de tiempo.
    public static func formatTime(_ time: TimeInterval) -> String {
        return time.toString()
    }
    
    /// Permite obtener una cadena de caracteres a partir de un Double que representa
    /// la altura de una actividad.
    /// - Parameter altitude: altura.
    /// - Returns: cadena de caracteres que representa la altura.
    public static func formatAltitude(_ altitude: Double) -> String {
        return String(format: "%.0f m", altitude)
    }
    
    /// Permite obtener una cadena de caracteres a partir de un Double que representa el
    /// ritmo del usuario al moverse.
    /// - Parameters:
    ///   - pace: ritmo del usuario.
    ///   - showUnit: índica si debe mostrarse la unidad del ritmo.
    /// - Returns: cadena de caracteres que representa el ritmo del usuario.
    public static func formatPace(_ pace: Double, showUnit: Bool = false) -> String {
        guard pace.isFinite && pace > 0 else { return "– min/km" }

        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        let format: String = (showUnit) ? "%d:%02d min/km" : "%d:%02d"
        return String(format: format, minutes, seconds)
    }

}
