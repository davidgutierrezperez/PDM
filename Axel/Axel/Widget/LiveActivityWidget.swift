//
//  LiveActivityWidget.swift
//  Axel
//
//  Created by David Gutierrez on 5/6/25.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct RunningLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RunningAttributes.self) { context in
            // Lock Screen/Banner UI
            VStack {
                Text("⏱️ \(FormatHelper.formatTime(context.state.elapsedTime))")
                    .font(.title2)
                Text(context.state.isPaused ? "Pausado" : "En curso")
                    .foregroundColor(context.state.isPaused ? .red : .green)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text("⏱️ \(FormatHelper.formatTime(context.state.elapsedTime))")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.isPaused ? "Pausado" : "Corriendo")
                }
            } compactLeading: {
                Image(systemName: SFSymbols.runner)
            } compactTrailing: {
                Text(FormatHelper.formatTime(context.state.elapsedTime))
            } minimal: {
                Text("🏃‍♂️")
            }
        }
    }
}
