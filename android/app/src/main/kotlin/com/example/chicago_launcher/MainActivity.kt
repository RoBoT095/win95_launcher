package com.example.win95_launcher

import android.content.ComponentName
import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "launcher_settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openLauncherChooser") {
                    try {
                        val intent = Intent(Settings.ACTION_HOME_SETTINGS)
                        startActivity(intent)
                        result.success(null)
                    } catch (e: Exception) {
                        try {
                            val selector = Intent(Intent.ACTION_MAIN)
                            selector.addCategory(Intent.CATEGORY_HOME)
                            selector.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            
                            val chooser = Intent.createChooser(selector, "Select Launcher")
                            startActivity(chooser)
                            result.success(null)
                        } catch (ex: Exception) {
                            result.error("ERROR", ex.message, null)
                        }
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}