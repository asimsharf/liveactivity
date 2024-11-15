package com.example.liveactivity

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.liveactivity.handlers.PollChannelHandler
import com.example.liveactivity.handlers.TimerChannelHandler
import com.example.liveactivity.handlers.WorkoutChannelHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private lateinit var pollChannelHandler: PollChannelHandler
    private lateinit var workoutChannelHandler: WorkoutChannelHandler
    private lateinit var timerChannelHandler: TimerChannelHandler

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize and set up channels
        pollChannelHandler = PollChannelHandler(this)
        workoutChannelHandler = WorkoutChannelHandler(this)
        timerChannelHandler = TimerChannelHandler(this)

        pollChannelHandler.setUpChannel(flutterEngine.dartExecutor)
        workoutChannelHandler.setUpChannel(flutterEngine.dartExecutor)
        timerChannelHandler.setUpChannel(flutterEngine.dartExecutor)
    }
}
