// MainActivity.kt

package com.example.liveactivity

import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private lateinit var pollChannelHandler: PollChannelHandler
    private lateinit var workoutChannelHandler: WorkoutChannelHandler

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize and set up channels
        pollChannelHandler = PollChannelHandler(this)
        workoutChannelHandler = WorkoutChannelHandler(this)

        pollChannelHandler.setUpChannel(flutterEngine.dartExecutor)
        workoutChannelHandler.setUpChannel(flutterEngine.dartExecutor)
    }
}
