//
//  ActivityRoute.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import Foundation

/// Modelo que representa la ruta de una actividad.
struct ActivityRoute {
    
    /// Identificador de la ruta de una actividad.
    let id: UUID
    
    /// Puntos que representa la ruta de una actividad.
    var points: [RoutePoint]
    
    /// Constructor por defecto. Crea una ruta vacía.
    init(){
        id = UUID()
        points = []
    }
    
    /// Constructor que crea una ruta completa.
    init(id: UUID, points: [RoutePoint]){
        self.id = id
        self.points = points
    }
}
