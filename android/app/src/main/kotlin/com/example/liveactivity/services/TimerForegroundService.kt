// TimerForegroundService.kt
package com.example.liveactivity.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.CountDownTimer
import android.os.IBinder
import android.os.SystemClock
import androidx.core.app.NotificationCompat
import com.example.liveactivity.R

class TimerForegroundService : Service() {

    private var timer: CountDownTimer? = null
    private var duration: Long = 0

    companion object {
        const val CHANNEL_ID = "TimerServiceChannel"
        const val ACTION_START_TIMER = "ACTION_START_TIMER"
        const val ACTION_STOP_TIMER = "ACTION_STOP_TIMER"
        const val EXTRA_DURATION = "EXTRA_DURATION"
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START_TIMER -> {
                duration = intent.getLongExtra(EXTRA_DURATION, 0)
                startForegroundService()
                startTimer()
            }
            ACTION_STOP_TIMER -> {
                stopTimer()
                stopSelf()
            }
        }
        return START_STICKY
    }

    private fun startForegroundService() {
        // Create a notification channel only if the API level is 26 or higher
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val notificationChannel = NotificationChannel(
                CHANNEL_ID,
                "Timer Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(notificationChannel)
        }

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Timer Running")
            .setContentText("Your timer is running")
            .setSmallIcon(R.drawable.ic_timer) // Make sure this is a valid drawable resource ID
            .build()


        // Start the foreground service with the notification
        startForeground(1, notification)
    }

    private fun startTimer() {
        timer = object : CountDownTimer(duration, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                // Here, you can send updates to the UI if needed.
            }

            override fun onFinish() {
                // Notify UI that timer is finished
                stopSelf()
            }
        }.start()
    }

    private fun stopTimer() {
        timer?.cancel()
        timer = null
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        stopTimer()
        super.onDestroy()
    }
}
