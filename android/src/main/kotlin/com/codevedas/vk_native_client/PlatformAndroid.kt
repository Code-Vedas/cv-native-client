package com.codevedas.vk_native_client

class PlatformAndroid {
    companion object {
        // Retrieve the Android version and send it back to Flutter
        fun platformVersion(): String {
            return android.os.Build.VERSION.RELEASE
        }
    }
}