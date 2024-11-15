//
//  PollActivityService.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// PollActivityService.swift

import ActivityKit

class PollActivityService {
    static let shared = PollActivityService()  // Singleton instance

    // Make the initializer private to prevent accidental instances
    private init() {}

    // Start a poll Live Activity with a countdown timer
    func startPollActivity(question: String, durationInSeconds: TimeInterval) {
        if #available(iOS 16.1, *) {
            let endTime = Date().addingTimeInterval(durationInSeconds)
            let attributes = PollAttributes(pollName: "Live Poll")
            let initialContentState = PollAttributes.ContentState(question: question, endTime: endTime)

            do {
                let activity = try Activity<PollAttributes>.request(
                    attributes: attributes,
                    contentState: initialContentState,
                    pushType: nil
                )
                print("Started Poll Live Activity with ID: \(activity.id)")
            } catch {
                print("Failed to start Poll Live Activity: \(error)")
            }
        } else {
            print("Live Activities are not available on this iOS version.")
        }
    }

    // Update an active poll Live Activity with new data
    func updatePollActivity(question: String) {
        if #available(iOS 16.1, *) {
            for activity in Activity<PollAttributes>.activities {
                var updatedContent = activity.contentState
                updatedContent.question = question // Update the poll question or other state info as needed

                Task {
                    await activity.update(using: updatedContent)
                }
            }
        }
    }

    // Stop all poll Live Activities
    func stopAllActivities() {
        if #available(iOS 16.1, *) {
            for activity in Activity<PollAttributes>.activities {
                Task {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }
        }
    }
}
