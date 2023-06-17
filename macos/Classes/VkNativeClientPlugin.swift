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
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString) // Return macOS version
        case "getClipboardText":
            // Get HTML from clipboard, if not HTML, return plain text
            let board = NSPasteboard.general
            
            if let html = board.string(forType: .html) ?? getRtfAsHtml() {
                result(html) // Return HTML text
            } else if let text = board.string(forType: .string) {
                result(text) // Return plain text
            } else {
                result(nil) // No clipboard content found
            }
        case "setClipboardText":
            // Set HTML to clipboard, if not HTML, set plain text
            let pasteboard = NSPasteboard.general
             if let html = call.arguments as? String {
                pasteboard.setString(html, forType: .html)
                result(true)
                return
             }
             result(false) // No clipboard content found
        default:
            result(FlutterMethodNotImplemented) // Method not implemented
        }
    }
    
    // Convert RTF data to HTML
    func getRtfAsHtml() -> String? {
        guard let boardRtf = NSPasteboard.general.data(forType: .rtf) else {
            return nil
        }
        guard let attrStr = NSAttributedString(rtf: boardRtf, documentAttributes: nil) else {
            return nil
        }
        guard let htmlData = try? attrStr.data(
            from: NSRange(location: 0, length: attrStr.length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.html])
        else {
            return nil
        }
        return String(data: htmlData, encoding: String.Encoding.utf8)
    }
}
