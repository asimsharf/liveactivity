package com.example.liveactivity.helpers

import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.liveactivity.services.PollForegroundService
import java.util.ArrayList
import kotlin.apply
import kotlin.jvm.java

object PollServiceHelper {
    fun startPollService(
        context: Context,
        question: String,
        options: List<String>,
        votes: List<Int>
    ) {
        val serviceIntent = Intent(context, PollForegroundService::class.java).apply {
            putExtra("question", question)
            putStringArrayListExtra("options", ArrayList(options))
            putIntegerArrayListExtra("votes", ArrayList(votes))
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }

    fun updatePollService(
        context: Context,
        question: String,
        options: List<String>,
        votes: List<Int>
    ) {
        val serviceIntent = Intent(context, PollForegroundService::class.java).apply {
            putExtra("question", question)
            putStringArrayListExtra("options", ArrayList(options))
            putIntegerArrayListExtra("votes", ArrayList(votes))
        }
        context.startService(serviceIntent)
    }

    fun stopPollService(context: Context) {
        val serviceIntent = Intent(context, PollForegroundService::class.java)
        context.stopService(serviceIntent)
    }
}
