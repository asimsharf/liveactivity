package com.example.liveactivity.handlers

import android.content.Context
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import com.example.liveactivity.helpers.TimerServiceHelper

class TimerChannelHandler(private val context: Context) {
    companion object {
        const val CHANNEL_NAME = "com.example.liveactivity/timerService"
    }

    fun setUpChannel(dartExecutor: DartExecutor) {
        val  channel = MethodChannel(dartExecutor.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startTimer" -> {
                    val duration = call.argument<Int>("duration") ?: 0
                    TimerServiceHelper.startTimerService(context, duration)
                    result.success("Timer started")
                }
                "stopTimer" -> {
                    TimerServiceHelper.stopTimerService(context)
                    result.success("Timer stopped")
                }
                else -> result.notImplemented()
            }
        }

    }
}