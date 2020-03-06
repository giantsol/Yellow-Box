package com.giantsol.yellow_box

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL_NAME = "com.giantsol.yellow_box"
        private const val METHOD_SHOW_MINI_BOX = "showMiniBox"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                if (call.method == METHOD_SHOW_MINI_BOX) {
                    result.success(true)
                } else {
                    result.notImplemented()
                }
            }
    }
}
