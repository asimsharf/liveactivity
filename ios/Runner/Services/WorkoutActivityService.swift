//
//  WorkoutLiveActivityService.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// WorkoutLiveActivityService.swift

import ActivityKit

class WorkoutActivityService {
    
    // Start workout Live Activity
    static func startWorkoutActivity(workoutType: String, goal: String) {
        if #available(iOS 16.1, *) {
            let initialContentState = WorkoutAttributes.ContentState(
                heartRate: 0,
                steps: 0,
                caloriesBurned: 0,
                elapsedTime: 0,
                goalProgress: 0
            )
            let activityAttributes = WorkoutAttributes(workoutType: workoutType, goal: goal)
            
            do {
                let activity = try Activity<WorkoutAttributes>.request(
                    attributes: activityAttributes,
                    contentState: initialContentState,
                    pushType: nil
                )
                
                print("Started Live Activity: \(activity.id)")
            } catch {
                print("Error starting Live Activity: \(error)")
            }
        }
    }
    
    // Update workout Live Activity
    static func updateWorkoutActivity(heartRate: Int, steps: Int, caloriesBurned: Int, elapsedTime: TimeInterval, goalProgress: Double) {
        if #available(iOS 16.1, *) {
            for activity in Activity<WorkoutAttributes>.activities {
                let updatedContentState = WorkoutAttributes.ContentState(
                    heartRate: heartRate,
                    steps: steps,
                    caloriesBurned: caloriesBurned,
                    elapsedTime: elapsedTime,
                    goalProgress: goalProgress
                )
                
                Task {
                    await activity.update(using: updatedContentState)
                }
            }
        }
    }
    
    // Stop workout Live Activity
    static func stopWorkoutActivity() {
        if #available(iOS 16.1, *) {
            for activity in Activity<WorkoutAttributes>.activities {
                Task {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }
        }
    }
}
