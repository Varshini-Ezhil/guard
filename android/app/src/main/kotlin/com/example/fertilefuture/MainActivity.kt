package com.example.fertilefuture

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.fertilefuture/roboflow"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "analyzeSoil") {
                val image = call.argument<String>("image")
                if (image != null) {
                    // Handle the image analysis here
                    try {
                        // For now, just return a dummy response
                        result.success("""{"success": true, "message": "Analysis complete"}""")
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                } else {
                    result.error("INVALID_IMAGE", "Image data is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
