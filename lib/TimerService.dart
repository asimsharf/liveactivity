// timer_activity_controller.dart

import 'package:flutter/services.dart';

class TimerService {
  static const MethodChannel _channel =
      MethodChannel('com.example.liveactivity/timerService');

  // Start the countdown timer Live Activity
  static Future<void> startCountdownTimer(double durationInSeconds) async {
    try {
      final result = await _channel.invokeMethod('startTimer', {
        'duration':
            durationInSeconds.toInt(), // Ensure it's an integer for Android
      });
      print(result);
    } catch (e) {
      print("Failed to start countdown timer: $e");
    }
  }

  // Stop the countdown timer Live Activity
  static Future<void> stopCountdownTimer() async {
    try {
      final result = await _channel.invokeMethod('stopTimer');
      print(result);
    } catch (e) {
      print("Failed to stop countdown timer: $e");
    }
  }
}
