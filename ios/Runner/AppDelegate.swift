import Flutter
import UIKit
import UserNotifications
import ActivityKit

struct PollAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var question: String
        var votes: [Int]
        var options: [String]
    }
    
    var question: String
}

@main
@objc class AppDelegate: FlutterAppDelegate {
    
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
                    result("success")
                    
                case "updateService":
                    if let args = call.arguments as? [String: Any],
                       let question = args["question"] as? String,
                       let votes = args["votes"] as? [Int] {
                        self?.updateLiveActivity(question: question, votes: votes)
                    }
                    result("success")
                    
                case "stopService":
                    self?.stopLiveActivity()
                    result(nil)

                case "startLiveActivity":
                         if let args = call.arguments as? [String: Any],
                                           let question = args["question"] as? String,
                                           let options = args["options"] as? [String],
                                           let votes = args["votes"] as? [Int] {
                                            self?.startLiveActivity(question: question, options: options, votes: votes)
                                        }
                    result("success")
                case "updateLiveActivity":
                             if let args = call.arguments as? [String: Any],
                                           let question = args["question"] as? String,
                                           let votes = args["votes"] as? [Int] {
                                            self?.updateLiveActivity(question: question, votes: votes)
                                        }
                    result("success")
                case "stopLiveActivity":
                                self?.stopLiveActivity()
                                        result("success")
                    
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Request notification permissions
    private func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
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
        content.categoryIdentifier = "pollUpdateCategory" // For lock screen display

        // Set interruptionLevel and relevanceScore if available on iOS 15+
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
            content.relevanceScore = 1.0
        }
        
        if #available(iOS 16.1, *) {
            let initialContentState = PollAttributes.ContentState(question: question, votes: votes, options: options)
            let activityAttributes = PollAttributes(question: question)
            
            do {
                let activity = try Activity<PollAttributes>.request(
                    attributes: activityAttributes,
                    contentState: initialContentState,
                    pushType: nil)
                
                print("Started Live Activity: \(activity.id)")
            } catch (let error) {
                print("Error starting Live Activity: \(error.localizedDescription)")
            }
        } else {
            print("Live Activities are not available on this iOS version.")
        }
        
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
        content.categoryIdentifier = "pollUpdateCategory"
        
        // Set interruptionLevel and relevanceScore if available on iOS 15+
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
            content.relevanceScore = 1.0
        }
        
        if #available(iOS 16.1, *) {
            for activity in Activity<PollAttributes>.activities {
                var updatedContent = activity.contentState
                updatedContent.votes = votes
                
                Task {
                    await activity.update(using: updatedContent)
                }
            }
        }
        
        // Schedule a notification update
        let request = UNNotificationRequest(identifier: "pollUpdate", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // Stop live activity (removes the notification)
    private func stopLiveActivity() {
        
        if #available(iOS 16.1, *) {
            for activity in Activity<PollAttributes>.activities {
                Task {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["pollUpdate"])
    }
    
    // Format the options and votes for display in the notification body
    private func formatOptions(options: [String], votes: [Int]) -> String {
        return zip(options, votes).map { "\($0): \($1) votes" }.joined(separator: "\n")
    }
}
