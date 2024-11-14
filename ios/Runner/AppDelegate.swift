import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
    
    private let channelName = "com.example.liveactivity/pollService"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Set up notification center delegate
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermissions()
        
        // Set up Flutter MethodChannel for communication
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
            
            channel.setMethodCallHandler { [weak self] call, result in
                switch call.method {
                case "startService":
                    if let args = call.arguments as? [String: Any],
                       let question = args["question"] as? String,
                       let options = args["options"] as? [String],
                       let votes = args["votes"] as? [Int] {
                        self?.startLiveActivity(question: question, options: options, votes: votes)
                    }
                    result(nil)
                    
                case "updateService":
                    if let args = call.arguments as? [String: Any],
                       let question = args["question"] as? String,
                       let votes = args["votes"] as? [Int] {
                        self?.updateLiveActivity(question: question, votes: votes)
                    }
                    result(nil)
                    
                case "stopService":
                    self?.stopLiveActivity()
                    result(nil)
                    
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Request notification permissions
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permissions granted")
            } else {
                print("Notification permissions denied")
            }
        }
    }
    
    // Start live activity (sends an initial notification)
    private func startLiveActivity(question: String, options: [String], votes: [Int]) {
        let content = UNMutableNotificationContent()
        content.title = question
        content.body = formatOptions(options: options, votes: votes)
        content.sound = .default
        
        // Trigger the notification immediately
        let request = UNNotificationRequest(identifier: "pollUpdate", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // Update live activity (updates the notification with new data)
    private func updateLiveActivity(question: String, votes: [Int]) {
        let content = UNMutableNotificationContent()
        content.title = question
        content.body = "Updated votes: \(votes)"
        content.sound = .default
        
        // Trigger the updated notification immediately
        let request = UNNotificationRequest(identifier: "pollUpdate", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // Stop live activity (removes the notification)
    private func stopLiveActivity() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["pollUpdate"])
    }
    
    // Format the options and votes for display in the notification body
    private func formatOptions(options: [String], votes: [Int]) -> String {
        return zip(options, votes).map { "\($0): \($1) votes" }.joined(separator: "\n")
    }
}
