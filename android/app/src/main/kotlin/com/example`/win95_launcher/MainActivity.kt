package com.example.win95_launcher

import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "custom_functions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openLauncherChooser" -> {
                        openLauncherSettings(result)
                    }
                    "openNotificationPanel" -> {
                        openNotifications(result)
                    }
                    // "lockScreen" -> {

                    // }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun openLauncherSettings(result: MethodChannel.Result) {
        try {
            val intent = Intent(Settings.ACTION_HOME_SETTINGS)
            startActivity(intent)
            result.success(null)
        } catch (e: Exception) {
            try {
                val selector = Intent(Intent.ACTION_MAIN).apply {
                    addCategory(Intent.CATEGORY_HOME)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                val chooser = Intent.createChooser(selector, "Select Launcher")
                startActivity(chooser)
                result.success(null)
            } catch (ex: Exception) {
                result.error("ERROR", ex.message, null)
            }
        }
    }

    private fun openNotifications(result: MethodChannel.Result) {
        try {
            val statusBarService = getSystemService("statusbar")
            val statusBarManager = Class.forName("android.app.StatusBarManager")
            val method = statusBarManager.getMethod("expandNotificationsPanel")
            method.invoke(statusBarService)
            result.success(null)
        } catch (e: Exception) {
            result.error("STATUS_BAR_ERROR", "Could not expand notification panel: ${e.message}", null)
        }
    }
}