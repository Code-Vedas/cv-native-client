package com.codevedas.vk_native_client

import android.content.ClipData
import android.content.Context
import android.os.Build
import android.text.Html
import android.content.ClipboardManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** Extension */
fun ClipData.Item.coerceToHtmlText(context: Context): String {
  val text = coerceToText(context).toString()
  return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      Html.fromHtml(text, Html.FROM_HTML_MODE_LEGACY).toString()
  } else {
      @Suppress("DEPRECATION")
      Html.fromHtml(text).toString()
  }
}

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
            "getPlatformVersion" -> platformVersion(result)
            "getClipboardText" -> getClipboardText(result)
            "setClipboardText" -> setClipboardText(call, result)
            else -> result.notImplemented() // Method not implemented
        }
    }

    // Retrieve the Android version and send it back to Flutter
    private fun platformVersion(result: Result) {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }

    // Get the text content from the clipboard and send it back to Flutter
    private fun getClipboardText(result: Result) {
        val clipboardManager = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?
        val clipData = clipboardManager?.primaryClip
        if (clipData != null && clipData.itemCount > 0) {
            val richText = clipData.getItemAt(0).coerceToHtmlText(context)
            result.success(richText)
        } else {
            result.success(null)
        }
    }

    // Set the text content of the clipboard with the provided HTML and notify Flutter
    private fun setClipboardText(call: MethodCall, result: Result) {
        val html = call.argument<String>("html")
        val clipboardManager = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?
        val clipData = ClipData.newPlainText(null, html)
        clipboardManager?.setPrimaryClip(clipData)
        result.success(null)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        // Clean up when detached from the Flutter engine
        channel.setMethodCallHandler(null)
    }
}