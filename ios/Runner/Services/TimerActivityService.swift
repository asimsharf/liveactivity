//
//  TimerActivityService.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//


import ActivityKit

class TimerActivityService {
    static let shared = TimerActivityService()  // Singleton instance

    // Make the initializer private to prevent accidental instances
    private init() {}

    // Start a countdown timer Live Activity
    func startCountdownTimer(durationInSeconds: TimeInterval) {
        if #available(iOS 16.1, *) {
            let endTime = Date().addingTimeInterval(durationInSeconds)
            let attributes = TimerAttributes()
            let initialContentState = TimerAttributes.ContentState(endTime: endTime)

            do {
                let activity = try Activity<TimerAttributes>.request(
                    attributes: attributes,
                    contentState: initialContentState,
                    pushType: nil
                )
                print("Started countdown timer Live Activity with ID: \(activity.id)")
            } catch {
                print("Failed to start countdown timer Live Activity: \(error)")
            }
        } else {
            print("Live Activities are not available on this iOS version.")
        }
    }

    // Stop all timer Live Activities
    func stopAllActivities() {
        if #available(iOS 16.1, *) {
            for activity in Activity<TimerAttributes>.activities {
                Task {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }
        }
    }
}
