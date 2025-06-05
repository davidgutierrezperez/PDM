//
//  LiveActivityManager.swift
//  Axel
//
//  Created by David Gutierrez on 5/6/25.
//

import ActivityKit
import CoreLocation

struct RunningAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var elapsedTime: TimeInterval
        var isPaused: Bool
    }
    
    var id: UUID
}

final class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private var currentActivity: ActivityKit.Activity<RunningAttributes>?
    
    private init(){}
    
    func startActivity(id: UUID) {
        let attributes = RunningAttributes(id: id)
        let initialState = RunningAttributes.ContentState(elapsedTime: 0, isPaused: false)
            
        do {
            let activity = try ActivityKit.Activity<RunningAttributes>.request(
                attributes: attributes,
                contentState: initialState,
                pushType: nil
            )
            currentActivity = activity
        } catch {
               print("Error al iniciar Live Activity: \(error)")
        }
    }

    func updateElapsedTime(_ duration: TimeInterval) {
        Task {
            let content = RunningAttributes.ContentState(elapsedTime: duration, isPaused: false)
            await currentActivity?.update(using: content)
        }
    }

    func endActivity() {
        Task {
            await currentActivity?.end(dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
}
