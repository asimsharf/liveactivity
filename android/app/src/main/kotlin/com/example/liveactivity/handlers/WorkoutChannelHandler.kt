package com.example.liveactivity.handlers

import android.content.Context
import com.example.liveactivity.helpers.WorkoutServiceHelper
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class WorkoutChannelHandler(private val context: Context) {
    companion object {
        const val CHANNEL_NAME = "com.example.healthapp/workoutService"
    }

    fun setUpChannel(dartExecutor: DartExecutor) {
        val channel = MethodChannel(dartExecutor.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startWorkout" -> {
                    val workoutType = call.argument<String>("workoutType") ?: "Workout"
                    val heartRate = call.argument<Int>("heartRate") ?: 0
                    val steps = call.argument<Int>("steps") ?: 0
                    val calories = call.argument<Int>("calories") ?: 0
                    val elapsedTime = call.argument<Int>("elapsedTime") ?: 0
                    WorkoutServiceHelper.startWorkoutService(context, workoutType, heartRate, steps, calories, elapsedTime)
                    result.success("Workout started")
                }
                "updateWorkout" -> {
                    val workoutType = call.argument<String>("workoutType") ?: "Workout"
                    val heartRate = call.argument<Int>("heartRate") ?: 0
                    val steps = call.argument<Int>("steps") ?: 0
                    val calories = call.argument<Int>("calories") ?: 0
                    val elapsedTime = call.argument<Int>("elapsedTime") ?: 0
                    WorkoutServiceHelper.updateWorkoutService(context, workoutType, heartRate, steps, calories, elapsedTime)
                    result.success("Workout updated")
                }
                "stopWorkout" -> {
                    WorkoutServiceHelper.stopWorkoutService(context)
                    result.success("Workout stopped")
                }
                else -> result.notImplemented()
            }
        }
    }
}
