package com.example.liveactivity.helpers

import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.liveactivity.services.WorkoutForegroundService
import kotlin.apply
import kotlin.jvm.java

object WorkoutServiceHelper {
    fun startWorkoutService(context: Context, workoutType: String, heartRate: Int, steps: Int, calories: Int, elapsedTime: Int) {
        val serviceIntent = Intent(context, WorkoutForegroundService::class.java).apply {
            putExtra("workoutType", workoutType)
            putExtra("heartRate", heartRate)
            putExtra("steps", steps)
            putExtra("calories", calories)
            putExtra("elapsedTime", elapsedTime)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }

    fun updateWorkoutService(context: Context, workoutType: String, heartRate: Int, steps: Int, calories: Int, elapsedTime: Int) {
        val serviceIntent = Intent(context, WorkoutForegroundService::class.java).apply {
            putExtra("workoutType", workoutType)
            putExtra("heartRate", heartRate)
            putExtra("steps", steps)
            putExtra("calories", calories)
            putExtra("elapsedTime", elapsedTime)
        }
        context.startService(serviceIntent)
    }

    fun stopWorkoutService(context: Context) {
        val serviceIntent = Intent(context, WorkoutForegroundService::class.java)
        context.stopService(serviceIntent)
    }
}
