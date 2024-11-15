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
        var heartRate: Int
        var steps: Int
        var caloriesBurned: Int
        var elapsedTime: TimeInterval
        var goalProgress: Double
    }
    
    var workoutType: String // e.g., Running, Walking, Cycling
    var goal: String // e.g., "5 km", "30 mins"
}
