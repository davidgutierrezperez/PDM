//
//  ActivityTimerManager.swift
//  Axel
//
//  Created by David Gutierrez on 3/6/25.
//

import Foundation

final class ActivityTimerManager {
    private var timer: Timer?
    private(set) var elapsed: TimeInterval = 0
    
    var onTick: ((TimeInterval) -> Void)?
    
    func start(interval: TimeInterval = 1.0){
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.elapsed += interval
            self.onTick?(self.elapsed)
        }
    }
    
    func stop(){
        timer?.invalidate()
        timer = nil
    }
    
    func reset(){
        elapsed = 0
        stop()
    }
}
