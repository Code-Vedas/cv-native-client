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
        case "getClipboardData":
            result(ClipboardIOS.getClipboardData()) // Get clipboard data
        case "setClipboardData":
            result(ClipboardIOS.setClipboardData(call: call)) // Set clipboard data
        case "getClipboardDataMimeTypes":
            result(ClipboardIOS.getClipboardDataMimeTypes()) // Get clipboard data MIME types
        default:
            result(FlutterMethodNotImplemented) // Method not implemented
        }
    }
}
