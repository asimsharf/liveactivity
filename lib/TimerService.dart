// timer_activity_controller.dart

import 'package:flutter/services.dart';

class TimerService {
  static const MethodChannel _channel =
      MethodChannel('com.example.dynamicIsland/timerService');

  // Start the countdown timer Live Activity
  static Future<void> startCountdownTimer(double durationInSeconds) async {
    try {
      await _channel.invokeMethod('startCountdownTimer', {
        'duration': durationInSeconds,
      });
    } catch (e) {
      print("Failed to start countdown timer: $e");
    }
  }

  // Stop all Live Activities
  static Future<void> stopAllActivities() async {
    try {
      await _channel.invokeMethod('stopAllActivities');
    } catch (e) {
      print("Failed to stop activities: $e");
    }
  }
}
