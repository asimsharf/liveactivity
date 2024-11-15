package com.example.liveactivity.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import com.example.liveactivity.R
import kotlin.apply
import kotlin.jvm.java

class WorkoutForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "WorkoutUpdatesChannel"
        const val NOTIFICATION_ID = 2
        const val ACTION_STOP = "STOP_WORKOUT_SERVICE"
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        if (action == ACTION_STOP) {
            stopForeground(true)
            stopSelf()
            return START_NOT_STICKY
        }

        val workoutType = intent?.getStringExtra("workoutType") ?: "Workout Session"
        val heartRate = intent?.getIntExtra("heartRate", 0) ?: 0
        val steps = intent?.getIntExtra("steps", 0) ?: 0
        val calories = intent?.getIntExtra("calories", 0) ?: 0
        val elapsedTime = intent?.getIntExtra("elapsedTime", 0) ?: 0

        startForeground(NOTIFICATION_ID, buildNotification(workoutType, formatWorkoutData(heartRate, steps, calories, elapsedTime)))
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Workout Updates",
            NotificationManager.IMPORTANCE_HIGH
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(title: String, content: String): Notification {
        val stopIntent = Intent(this, WorkoutForegroundService::class.java).apply {
            action = ACTION_STOP
        }
        val pendingStopIntent = PendingIntent.getService(
            this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(content)
            .setSmallIcon(R.drawable.ic_workout)
            .addAction(R.drawable.ic_stop, "Stop", pendingStopIntent)
            .setOngoing(true)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()
    }

    private fun formatWorkoutData(heartRate: Int, steps: Int, calories: Int, elapsedTime: Int): String {
        return "Heart Rate: $heartRate BPM\nSteps: $steps\nCalories: $calories\nTime: ${elapsedTime}s"
    }
}
