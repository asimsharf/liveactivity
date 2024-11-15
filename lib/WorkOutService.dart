import 'package:flutter/services.dart';

class WorkoutService {
  static const MethodChannel _channel =
      MethodChannel('com.example.healthapp/workoutService');

  static Future<void> startWorkout(String workoutType, String goal) async {
    final result = await _channel.invokeMethod(
      'startWorkout',
      {
        'workoutType': workoutType,
        'goal': goal,
      },
    );
    print("Workout started: $result");
  }

  static Future<void> updateWorkout(int heartRate, int steps,
      int caloriesBurned, double elapsedTime, double goalProgress) async {
    final result = await _channel.invokeMethod(
      'updateWorkout',
      {
        'heartRate': heartRate,
        'steps': steps,
        'caloriesBurned': caloriesBurned,
        'elapsedTime': elapsedTime,
        'goalProgress': goalProgress,
      },
    );
    print("Workout updated: $result");
  }

  static Future<void> stopWorkout() async {
    final result = await _channel.invokeMethod('stopWorkout');
    print("Workout stopped: $result");
  }
}
