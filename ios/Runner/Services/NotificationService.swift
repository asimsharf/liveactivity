//
//  NotificationService.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// NotificationService.swift

import UserNotifications

class NotificationService {
    
    // Request notification permissions
    static func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                print("Notification permissions granted")
            } else {
                print("Notification permissions denied")
            }
        }
    }
    
    // Create a formatted notification content
    static func createNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "pollUpdateCategory"
        
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
            content.relevanceScore = 1.0
        }
        
        return content
    }
    
    // Display the notification
    static func displayNotification(content: UNMutableNotificationContent) {
        let request = UNNotificationRequest(identifier: "pollUpdate", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // Format the options and votes for display in the notification body
    static func formatOptions(options: [String], votes: [Int]) -> String {
        return zip(options, votes).map { "\($0): \($1) votes" }.joined(separator: "\n")
    }
}
