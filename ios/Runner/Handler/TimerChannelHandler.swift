//
//  TimerChannelHandler.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// TimerChannelHandler.swift

import Flutter
import ActivityKit

class TimerChannelHandler {
    private static let channelName = "com.example.dynamicIsland/timerService"

    static func setUpChannel(with controller: FlutterViewController) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "startCountdownTimer":
                if let args = call.arguments as? [String: Any],
                   let duration = args["duration"] as? Double {
                    TimerActivityService.shared.startCountdownTimer(durationInSeconds: duration)
                    result("Countdown timer started")
                }
            case "stopAllActivities":
                TimerActivityService.shared.stopAllActivities()
                result("All timers stopped")
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
