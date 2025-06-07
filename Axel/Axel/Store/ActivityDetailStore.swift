//
//  ActivityDetailStore.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import Foundation

/// Clase que gestiona la información temporal de la actividad
/// actual o más reciente creada por el usuario. Se utiliza para
/// solo tener que almacenar en memoria un única actividad.
final class ActivityDetailStore {
    
    /// Instancia única de la clase.
    static let shared = ActivityDetailStore()
    
    /// Objeto que permite interactuar con CoreData.
    private let repository = ActivityRepository.shared
    
    /// Actividad almacenada en memoria.
    private(set) var activity: Activity?
    
    /// Constructor por defecto 
    private init(){}
    
    func loadActivity(id: UUID){
        activity = repository.fetchById(id: id)
    }
    
    func loadActivity(activity: Activity?){
        self.activity = activity
    }
    
    func clear(){
        self.activity = nil
    }
}
