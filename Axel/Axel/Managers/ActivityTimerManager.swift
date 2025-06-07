//
//  ActivityTimerManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import Foundation

/// Clase que gestiona el temporizar de una actividad dada.
final class ActivityTimerManager {
    
    /// Fecha de inicio de la actividad.
    private var startDate = Date()
    
    /// Temporizador de la actividad.
    private var timer: Timer?
    
    /// Tiempo de la actividad.
    private(set) var elapsed: TimeInterval = 0
    
    /// Closure que permite indicar a una clase padre el tiempo de la actividad.
    var onTick: ((TimeInterval) -> Void)?
    
    /// Inicia el temporizar de una actividad.
    /// - Parameter interval: intervalo de tiempo en el que temporizar se actualizará.
    func start(interval: TimeInterval = 1.0){
        startDate = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            let now = Date()
            let delta = now.timeIntervalSince(self.startDate)
            self.elapsed += delta
            self.startDate = now
                        
            let roundedElapsed = floor(self.elapsed)
            self.onTick?(roundedElapsed)
        }
    }
    
    /// Detiene el temporizador.
    func stop(){
        let delta = Date().timeIntervalSince(self.startDate)
        self.elapsed += delta
        timer?.invalidate()
        timer = nil
    }
    
    /// Reinicia el temporizador por completo.
    func reset(){
        elapsed = 0
        stop()
    }
    
    /// Actualiza el tiempo del temporizador.
    func updateElpased(){
        let now = Date()
        let interval = now.timeIntervalSince(self.startDate)
        self.elapsed += interval
        self.startDate = now
        self.onTick?(floor(self.elapsed))
    }
}
