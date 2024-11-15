//
//  PollChannelHandler.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// PollChannelHandler.swift

import Flutter
import ActivityKit
import UserNotifications

class PollChannelHandler {
    static let channelName = "com.example.liveactivity/pollService"
    
    static func setUpChannel(with controller: FlutterViewController) {
        let pollChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        pollChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "startService":
                if let args = call.arguments as? [String: Any],
                   let question = args["question"] as? String,
                   let options = args["options"] as? [String],
                   let votes = args["votes"] as? [Int] {
                    LiveActivityService.startLiveActivity(question: question, options: options, votes: votes)
                    let contentBody = NotificationService.formatOptions(options: options, votes: votes)
                    let content = NotificationService.createNotificationContent(title: question, body: contentBody)
                    NotificationService.displayNotification(content: content)
                    result("Poll started")
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for startService", details: nil))
                }
                
            case "updateService":
                if let args = call.arguments as? [String: Any],
                   let question = args["question"] as? String,
                   let votes = args["votes"] as? [Int] {
                    LiveActivityService.updateLiveActivity(question: question, votes: votes)
                    let content = NotificationService.createNotificationContent(title: question, body: "Updated votes: \(votes)")
                    NotificationService.displayNotification(content: content)
                    result("Poll updated")
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for updateService", details: nil))
                }
                
            case "stopService":
                LiveActivityService.stopLiveActivity()
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["pollUpdate"])
                result("Poll stopped")
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
