//
//  WorkoutAttributes.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// WorkoutAttributes.swift

import ActivityKit

struct WorkoutAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var heartRate: Int          // Current heart rate
        var steps: Int              // Steps taken
        var caloriesBurned: Int     // Calories burned
        var elapsedTime: TimeInterval // Time elapsed since the start of workout
        var goalProgress: Double    // Progress towards workout goal (e.g., percentage)
    }
    
    var workoutType: String        // Type of workout, e.g., "Running", "Cycling"
    var goal: String               // The goal of the workout session, e.g., "5K Run"
}
