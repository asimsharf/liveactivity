// PollChannelHandler.kt

package com.example.liveactivity

import android.content.Context
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class PollChannelHandler(private val context: Context) {
    companion object {
        const val CHANNEL_NAME = "com.example.liveactivity/pollService"
    }

    fun setUpChannel(dartExecutor: DartExecutor) {
        val channel = MethodChannel(dartExecutor.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val question = call.argument<String>("question") ?: ""
                    val options = call.argument<List<String>>("options") ?: listOf()
                    val votes = call.argument<List<Int>>("votes") ?: listOf()
                    PollServiceHelper.startPollService(context, question, options, votes)
                    result.success("Poll started")
                }
                "updateService" -> {
                    val question = call.argument<String>("question") ?: ""
                    val options = call.argument<List<String>>("options") ?: listOf()
                    val votes = call.argument<List<Int>>("votes") ?: listOf()
                    PollServiceHelper.updatePollService(context, question, options, votes)
                    result.success("Poll updated")
                }
                "stopService" -> {
                    PollServiceHelper.stopPollService(context)
                    result.success("Poll stopped")
                }
                else -> result.notImplemented()
            }
        }
    }
}
