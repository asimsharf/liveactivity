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
        var workoutType: String  // Type of workout, e.g., "Running", "Cycling"
        var endTime: Date        // The end time for the workout, used for countdown
    }
    
    var workoutSession: String  // The name or description of the workout session
}
