import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Initialize Notification Service
        NotificationService.shared.requestNotificationPermissions()
        NotificationService.shared.setUpNotificationCategories()
        
        // Set up Flutter MethodChannels for workout, poll, and timer services
        if let controller = window?.rootViewController as? FlutterViewController {
            WorkoutChannelHandler.setUpChannel(with: controller)
            PollChannelHandler.setUpChannel(with: controller)
            TimerChannelHandler.setUpChannel(with: controller)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
