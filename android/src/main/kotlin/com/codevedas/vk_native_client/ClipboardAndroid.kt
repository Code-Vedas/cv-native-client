// MIT License
//
// Copyright (c) 2023 Code Vedas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
package com.codevedas.vk_native_client

import android.content.ClipData
import android.content.Context
import android.content.ClipboardManager
import android.os.Build
import io.flutter.plugin.common.MethodCall

/// ClipboardAndroid is a static class that provides methods for interacting with the clipboard
/// on Android.
class ClipboardAndroid {
    companion object {
        /// Get data from the clipboard and return it as a map of strings.
        ///
        /// Parameters:
        /// - context - The application context.
        ///
        /// Returns:
        /// - Map<String, String> - A map of strings containing the plain text and HTML text from the clipboard.
        ///   - "plainText" - The plain text from the clipboard.
        ///   - "htmlText" - The HTML text from the clipboard.
        fun getClipboardData(context: Context): Map<String, String> {
            val clipboardManager =
                context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?
            val clipData = clipboardManager?.primaryClip
            val map: MutableMap<String, String> = HashMap()

            if (clipData != null && clipData.itemCount > 0) {
                val item = clipData.getItemAt(0)
                if (item.text != null) {
                    /// The clipboard contains plain text, add it to the map
                    map["plainText"] = item.text.toString()
                }
                if (item.htmlText != null) {
                    /// The clipboard contains HTML text, add it to the map
                    map["htmlText"] = item.htmlText.toString()
                }
            }
            /// Return the map    
            return map
        }

        /// Set the data on the clipboard.
        ///
        /// Parameters:
        /// - call - The method call from Flutter.
        /// - context - The application context.
        ///
        /// Returns:
        /// - bool - True if the data was set on the clipboard, false otherwise.
        fun setClipboardData(call: MethodCall, context: Context): Boolean {
            /// Get the plain text and HTML text from the method call
            val plainText = call.argument<String>("plainText")
            val htmlText = call.argument<String>("htmlText")

            val clipboardManager =
                context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?

            if (plainText != null && htmlText != null && clipboardManager != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    /// Clear the clipboard, if supported
                    clipboardManager.clearPrimaryClip()
                }
                /// Set the clipboard data    
                val clipData = ClipData.newHtmlText("text/plain", plainText, htmlText)
                clipboardManager.setPrimaryClip(clipData)
                return true
            }
            return false
        }


        /// Get the MIME types of the data on the clipboard.
        ///
        /// Parameters:
        /// - context - The application context.
        ///
        /// Returns:
        /// - List<String> - A list of strings containing the MIME types of the data on the clipboard.
        fun getClipboardDataMimeTypes(context: Context): List<String> {
            val clipboardManager =
                context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager?
            val clipData = clipboardManager?.primaryClip
            val mimeTypes: MutableList<String> = ArrayList()
            if (clipData != null && clipData.itemCount > 0) {
                val item = clipData.getItemAt(0)
                if (item.text != null) {
                    /// The clipboard contains plain text, add it to the list
                    mimeTypes.add("plainText")
                }
                if (item.htmlText != null) {
                    /// The clipboard contains HTML text, add it to the list
                    mimeTypes.add("htmlText")
                }
            }
            return mimeTypes
        }
    }
}