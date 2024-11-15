// PollServiceHelper.kt

package com.example.liveactivity

import android.content.Context
import android.content.Intent

object PollServiceHelper {
    fun startPollService(context: Context, question: String, options: List<String>, votes: List<Int>) {
        val serviceIntent = Intent(context, PollForegroundService::class.java).apply {
            putExtra("question", question)
            putStringArrayListExtra("options", ArrayList(options))
            putIntegerArrayListExtra("votes", ArrayList(votes))
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }

    fun updatePollService(context: Context, question: String, options: List<String>, votes: List<Int>) {
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
