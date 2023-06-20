package com.codevedas.vk_native_client

import android.content.ClipData
import android.content.Context
import android.content.ClipboardManager
import android.os.Build
import io.flutter.plugin.common.MethodCall

/** ClipboardAndroid */
class ClipboardAndroid {
    companion object {
        // static canCopyFromClipboard returns bool
        fun canCopyFromClipboard(context: Context): Boolean {
            val clipboardManager =
                context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?
            val clipData = clipboardManager?.primaryClip
            return clipData != null && clipData.itemCount > 0
        }

        // Get the text content from the clipboard and send it back to Flutter
        // Returns a String,String map
        fun getClipboardText(context: Context): Map<String, String> {
            val clipboardManager =
                context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?
            val clipData = clipboardManager?.primaryClip
            val map: MutableMap<String, String> = HashMap()

            if (clipData != null && clipData.itemCount > 0) {
                val item = clipData.getItemAt(0)
                if (item.text != null) {
                    map["plainText"] = item.text.toString()
                }
                if (item.htmlText != null) {
                    map["htmlText"] = item.htmlText.toString()
                }
            }

            return map
        }

        // Set the text content of the clipboard with the provided HTML and notify Flutter
        fun setClipboardText(call: MethodCall, context: Context): Boolean {
            val plainText = call.argument<String>("plainText")
            val htmlText = call.argument<String>("htmlText")

            val clipboardManager =
                context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?

            if (plainText != null && htmlText != null && clipboardManager != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    clipboardManager.clearPrimaryClip()
                }

                val clipData = ClipData.newHtmlText("text/plain", plainText, htmlText)
                clipboardManager.setPrimaryClip(clipData)
                return true
            }
            return false
        }
    }
}