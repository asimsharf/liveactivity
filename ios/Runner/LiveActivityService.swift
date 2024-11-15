//
//  LiveActivityService.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// LiveActivityService.swift

import ActivityKit

class LiveActivityService {
    
    // Start live activity
    static func startLiveActivity(question: String, options: [String], votes: [Int]) {
        if #available(iOS 16.1, *) {
            let initialContentState = PollAttributes.ContentState(question: question, votes: votes, options: options)
            let activityAttributes = PollAttributes(question: question)
            
            do {
                let activity = try Activity<PollAttributes>.request(
                    attributes: activityAttributes,
                    contentState: initialContentState,
                    pushType: nil
                )
                print("Started Live Activity: \(activity.id)")
            } catch {
                print("Error starting Live Activity: \(error.localizedDescription)")
            }
        } else {
            print("Live Activities are not available on this iOS version.")
        }
    }
    
    // Update live activity
    static func updateLiveActivity(question: String, votes: [Int]) {
        if #available(iOS 16.1, *) {
            for activity in Activity<PollAttributes>.activities {
                var updatedContent = activity.contentState
                updatedContent.votes = votes
                
                Task {
                    await activity.update(using: updatedContent)
                }
            }
        }
    }
    
    // Stop live activity
    static func stopLiveActivity() {
        if #available(iOS 16.1, *) {
            for activity in Activity<PollAttributes>.activities {
                Task {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }
        }
    }
}
