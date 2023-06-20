import Cocoa
import FlutterMacOS

// MIME types
let mimeTextPlain = "text/plain"
let mimeTextHtml = "text/html"

public class VkNativeClientPlugin: NSObject, FlutterPlugin {
    // Register the plugin with the Flutter engine
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vk_native_client", binaryMessenger: registrar.messenger)
        let instance = VkNativeClientPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // Handle method calls from Flutter
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + PlatformMacOS.getPlatformVersion()) // Return macOS version
        case "getClipboardText":
            result(ClipboardMacOS.getClipboardText()) // Return clipboard content (plainText and htmlText
        case "setClipboardText":
            result(ClipboardMacOS.setClipboardText(call: call)) // Set clipboard content (plainText and htmlText)
        case "canCopyFromClipboard":
            result(ClipboardMacOS.canCopyFromClipboard()) // Return true if clipboard content found, false otherwise
        default:
            result(FlutterMethodNotImplemented) // Method not implemented
        }
    }
    
    
}
