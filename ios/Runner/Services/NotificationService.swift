// NotificationService.swift
import UIKit
import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationService()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Request notification permissions
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                print("Notification permissions granted")
            } else {
                print("Notification permissions denied")
            }
        }
    }
    
    // Set up custom notification categories
    func setUpNotificationCategories() {
        let pollUpdateCategory = UNNotificationCategory(
            identifier: "pollUpdateCategory",
            actions: [], // Add any custom actions here if needed
            intentIdentifiers: [],
            options: []
        )
        
        // Register the categories with UNUserNotificationCenter
        UNUserNotificationCenter.current().setNotificationCategories([pollUpdateCategory])
    }
    
    // Handle notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display the notification with sound, alert, and badge while in the foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    // Handle notification responses (optional)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Process user interactions with notifications here if you add custom actions
        if response.notification.request.content.categoryIdentifier == "pollUpdateCategory" {
            print("User interacted with a poll update notification.")
        }
        
        completionHandler()
    }
}
