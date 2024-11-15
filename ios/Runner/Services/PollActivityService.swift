//
//  PollActivityService.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

import ActivityKit

class PollActivityService {
    static let shared = PollActivityService()  // Singleton instance

    // Make the initializer private to enforce singleton usage
    private init() {}

    // Start a poll Live Activity with options and votes
    func startPollActivity(question: String, options: [String], votes: [Int]) {
        if #available(iOS 16.1, *) {
            let endTime = Date().addingTimeInterval(60 * 5) // Example: 5-minute countdown
            let attributes = PollAttributes(pollName: "Live Poll")
            let initialContentState = PollAttributes.ContentState(question: question, options: options, votes: votes, endTime: endTime)

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
        }
    }

    // Update the poll Live Activity with new votes
    func updatePollActivity(question: String, votes: [Int]) {
        if #available(iOS 16.1, *) {
            for activity in Activity<PollAttributes>.activities {
                var updatedContent = activity.contentState
                updatedContent.question = question
                updatedContent.votes = votes // Update with new votes

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
