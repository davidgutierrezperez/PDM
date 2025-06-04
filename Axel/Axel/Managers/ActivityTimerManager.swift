//
//  ActivityTimerManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import Foundation

final class ActivityTimerManager {
    private var startDate = Date()
    private var timer: Timer?
    private(set) var elapsed: TimeInterval = 0
    
    var onTick: ((TimeInterval) -> Void)?
    
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
    
    func stop(){
        let delta = Date().timeIntervalSince(self.startDate)
        self.elapsed += delta
        timer?.invalidate()
        timer = nil
    }
    
    func reset(){
        elapsed = 0
        stop()
    }
    
    func updateElpased(){
        let now = Date()
        let interval = now.timeIntervalSince(self.startDate)
        self.elapsed += interval
        self.startDate = now
        self.onTick?(floor(self.elapsed))
    }
}
