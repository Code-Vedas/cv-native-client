package com.codevedas.vk_native_client


import android.content.Context

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** VkNativeClientPlugin */
class VkNativeClientPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        // Create a MethodChannel to communicate with Flutter
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vk_native_client")
        channel.setMethodCallHandler(this)

        // Store the application context
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        // Handle method calls from Flutter
        when (call.method) {
            /// getClipboardData returns Map<String, String>
            "getClipboardData" -> result.success(ClipboardAndroid.getClipboardData(context))
            /// setClipboardData returns bool
            "setClipboardData" -> result.success(ClipboardAndroid.setClipboardData(call, context))
            /// getClipboardDataMimeTypes returns List<String>
            "getClipboardDataMimeTypes" -> result.success(ClipboardAndroid.getClipboardDataMimeTypes(context))
            else -> result.notImplemented() // Method not implemented
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        // Clean up when detached from the Flutter engine
        channel.setMethodCallHandler(null)
    }
}