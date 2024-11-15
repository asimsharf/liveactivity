package com.example.liveactivity.helpers

import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.liveactivity.services.TimerForegroundService

object TimerServiceHelper {
    fun startTimerService(context: Context, duration: Int) {
        val intent = Intent(context, TimerForegroundService::class.java).apply {
            action = TimerForegroundService.ACTION_START_TIMER
            putExtra(TimerForegroundService.EXTRA_DURATION, duration.toLong())
        }

        // Use startForegroundService on API 26+, otherwise use startService
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
            context.startService(intent)
        } else {
            context.startService(intent)
        }
    }

    fun stopTimerService(context: Context) {
        val intent = Intent(context, TimerForegroundService::class.java).apply {
            action = TimerForegroundService.ACTION_STOP_TIMER
        }
        context.startService(intent)
    }
}
