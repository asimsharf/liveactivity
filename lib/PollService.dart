import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PollService {
  static const MethodChannel _channel =
      MethodChannel('com.example.liveactivity/pollService');

  static Future<void> startService(
    String question,
    List<String> options,
    List<int> votes,
  ) async {
    try {
      await _channel.invokeMethod(
        'startService',
        {
          'question': question,
          'options': options,
          'votes': votes,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error starting service: $e");
      }
    }
  }

  static Future<void> updateService(
    String question,
    List<int> votes,
  ) async {
    try {
      await _channel.invokeMethod(
        'updateService',
        {
          'question': question,
          'votes': votes,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error updating service: $e");
      }
    }
  }

  static Future<void> stopService() async {
    try {
      await _channel.invokeMethod('stopService');
    } catch (e) {
      if (kDebugMode) {
        print("Error stopping service: $e");
      }
    }
  }
}
