//
//  WorkoutChannelHandler.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//


import Flutter
import ActivityKit

class WorkoutChannelHandler {
    static let channelName = "com.example.healthapp/workoutService"
    
    static func setUpChannel(with controller: FlutterViewController) {
        let workoutChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        workoutChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "startWorkout":
                if let args = call.arguments as? [String: Any],
                   let workoutType = args["workoutType"] as? String,
                   let goal = args["goal"] as? String {
                    WorkoutActivityService.startWorkoutActivity(workoutType: workoutType, goal: goal)
                    result("Workout started")
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for startWorkout", details: nil))
                }
                
            case "updateWorkout":
                if let args = call.arguments as? [String: Any],
                   let heartRate = args["heartRate"] as? Int,
                   let steps = args["steps"] as? Int,
                   let caloriesBurned = args["caloriesBurned"] as? Int,
                   let elapsedTime = args["elapsedTime"] as? TimeInterval,
                   let goalProgress = args["goalProgress"] as? Double {
                    WorkoutActivityService.updateWorkoutActivity(
                        heartRate: heartRate,
                        steps: steps,
                        caloriesBurned: caloriesBurned,
                        elapsedTime: elapsedTime,
                        goalProgress: goalProgress
                    )
                    result("Workout updated")
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for updateWorkout", details: nil))
                }
                
            case "stopWorkout":
                WorkoutActivityService.stopWorkoutActivity()
                result("Workout stopped")
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
