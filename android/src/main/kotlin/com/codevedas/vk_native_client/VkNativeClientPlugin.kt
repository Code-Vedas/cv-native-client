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
            "getPlatformVersion" -> result.success("Android ${PlatformAndroid.platformVersion()}")
            "getClipboardText" -> result.success(ClipboardAndroid.getClipboardText(context))
            "setClipboardText" -> result.success(ClipboardAndroid.setClipboardText(call, context))
            "canCopyFromClipboard" -> result.success(ClipboardAndroid.canCopyFromClipboard(context))
            else -> result.notImplemented() // Method not implemented
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        // Clean up when detached from the Flutter engine
        channel.setMethodCallHandler(null)
    }
}