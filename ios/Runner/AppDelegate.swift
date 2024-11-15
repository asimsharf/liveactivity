import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Set up notification center delegate for handling notifications in the foreground
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        NotificationService.requestNotificationPermissions()
        
        // Set up notification categories for custom actions (if needed)
        setUpNotificationCategories()
        
        // Set up Flutter MethodChannels for workout, poll, and timer services
        if let controller = window?.rootViewController as? FlutterViewController {
            WorkoutChannelHandler.setUpChannel(with: controller)
            PollChannelHandler.setUpChannel(with: controller)
            TimerChannelHandler.setUpChannel(with: controller)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Set up custom notification categories
    private func setUpNotificationCategories() {
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
