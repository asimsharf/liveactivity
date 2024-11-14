package com.example.liveactivity

import android.content.Intent
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.liveactivity/pollService"

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val question = call.argument<String>("question") ?: ""
                    val options = call.argument<List<String>>("options") ?: listOf()
                    val votes = call.argument<List<Int>>("votes") ?: listOf()
                    startPollService(question, options, votes)
                    result.success("success")
                }
                "updateService" -> {
                    val question = call.argument<String>("question") ?: ""
                    val options = call.argument<List<String>>("options") ?: listOf()
                    val votes = call.argument<List<Int>>("votes") ?: listOf()
                    updatePollService(question, options, votes)
                    result.success("success")
                }
                "stopService" -> {
                    stopPollService()
                    result.success("success")
                }
                else -> result.notImplemented()
            }
        }
    }



    @RequiresApi(Build.VERSION_CODES.M)
    private fun startPollService(question: String, options: List<String>, votes: List<Int>) {
        val serviceIntent = Intent(this, PollForegroundService::class.java).apply {
            putExtra("question", question)
            putStringArrayListExtra("options", ArrayList(options))
            putIntegerArrayListExtra("votes", ArrayList(votes))
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun updatePollService(question: String, options: List<String>, votes: List<Int>) {
        val serviceIntent = Intent(this, PollForegroundService::class.java).apply {
            putExtra("question", question)
            putStringArrayListExtra("options", ArrayList(options))
            putIntegerArrayListExtra("votes", ArrayList(votes))
        }
        startService(serviceIntent)
    }

    private fun stopPollService() {
        val serviceIntent = Intent(this, PollForegroundService::class.java)
        stopService(serviceIntent)
    }
}
