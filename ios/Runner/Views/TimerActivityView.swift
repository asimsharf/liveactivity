// TimerActivityView.swift

import SwiftUI
import ActivityKit

struct TimerActivityView: View {
    let context: ActivityViewContext<TimerAttributes>

    var body: some View {
        VStack {
            Text("Countdown Timer")
                .font(.headline)
                .padding(.bottom, 8)

            Text(timerRemainingString(from: context.state.endTime))
                .font(.largeTitle)
                .bold()

            ProgressView(value: progressPercentage())
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
        }
        .padding()
    }

    // Helper function to calculate the remaining time
    private func timerRemainingString(from endTime: Date) -> String {
        let remainingTime = endTime.timeIntervalSince(Date())
        return remainingTime > 0 ? "\(Int(remainingTime))s left" : "Time's up!"
    }

    private func progressPercentage() -> Double {
        let duration = context.state.endTime.timeIntervalSince(context.attributes.startTime)
        let remainingTime = context.state.endTime.timeIntervalSince(Date())
        return 1.0 - max(remainingTime / duration, 0)
    }
}
