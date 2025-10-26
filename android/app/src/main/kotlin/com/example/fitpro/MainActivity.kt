package com.annotex.PureFit

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "step_tracking_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startForegroundService" -> {
                    startForegroundService()
                    result.success(null)
                }
                "stopForegroundService" -> {
                    stopForegroundService()
                    result.success(null)
                }
                "getCurrentSteps" -> {
                    val steps = getCurrentStepsFromService()
                    result.success(steps)
                }
                "updateGoal" -> {
                    val goal = call.argument<Int>("goal") ?: call.arguments as? Int ?: 1000
                    updateGoalInService(goal)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startForegroundService() {
        val serviceIntent = Intent(this, BackgroundStepService::class.java)
        startForegroundService(serviceIntent)
    }

    private fun stopForegroundService() {
        val serviceIntent = Intent(this, BackgroundStepService::class.java)
        stopService(serviceIntent)
    }

    private fun getCurrentStepsFromService(): Int {
        val prefs = getSharedPreferences("step_tracking", android.content.Context.MODE_PRIVATE)
        return prefs.getInt("currentSteps", 0)
    }
    
    private fun updateGoalInService(goal: Int) {
        val prefs = getSharedPreferences("step_tracking", android.content.Context.MODE_PRIVATE)
        prefs.edit().putInt("stepGoal", goal).apply()
    }
}
