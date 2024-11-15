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
import kotlin.collections.joinToString
import kotlin.collections.zip
import kotlin.jvm.java


class PollForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "PollUpdatesChannel"
        const val NOTIFICATION_ID = 1
        const val ACTION_STOP = "STOP_SERVICE"
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

        val question = intent?.getStringExtra("question") ?: "Live Poll Update"
        val options = intent?.getStringArrayListExtra("options") ?: arrayListOf()
        val votes = intent?.getIntegerArrayListExtra("votes") ?: arrayListOf()

        startForeground(NOTIFICATION_ID, buildNotification(question, formatOptions(options, votes)))
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Poll Updates",
            NotificationManager.IMPORTANCE_HIGH // Set to high to show on lock screen
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(title: String, content: String): Notification {
        val stopIntent = Intent(this, PollForegroundService::class.java).apply {
            action = ACTION_STOP
        }
        val pendingStopIntent = PendingIntent.getService(
            this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(content)
            .setSmallIcon(R.drawable.ic_poll)
            .addAction(R.drawable.ic_stop, "Stop", pendingStopIntent)
            .setOngoing(true)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC) // This line makes it visible on the lock screen
            .build()
    }

    private fun formatOptions(options: List<String>, votes: List<Int>): String {
        return options.zip(votes).joinToString("\n") { (option, vote) -> "$option: $vote votes" }
    }
}
