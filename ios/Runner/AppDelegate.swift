// AppDelegate.swift

import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Set up notification center delegate
        UNUserNotificationCenter.current().delegate = self
        NotificationService.requestNotificationPermissions()
        
        // Set up channels for workout and poll services
        if let controller = window?.rootViewController as? FlutterViewController {
            WorkoutChannelHandler.setUpChannel(with: controller)
            PollChannelHandler.setUpChannel(with: controller)
            TimerChannelHandler.setUpChannel(with: controller)

        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
