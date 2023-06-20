import Flutter

public class VkNativeClientPlugin: NSObject, FlutterPlugin {
    // Register the plugin with the Flutter engine
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vk_native_client", binaryMessenger: registrar.messenger())
        let instance = VkNativeClientPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // Handle method calls from Flutter
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + PlatformIOS.getPlatformVersion()) // Return iOS version
        case "getClipboardText":
            result(ClipboardIOS.getClipboardText()) // Get clipboard text
        case "setClipboardText":
            result(ClipboardIOS.setClipboardText(call: call)) // Set clipboard text
        case "canCopyFromClipboard":
            result(ClipboardIOS.canCopyFromClipboard()) // Check if clipboard is available
        default:
            result(FlutterMethodNotImplemented) // Method not implemented
        }
    }
}
