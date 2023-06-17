import Flutter
import UniformTypeIdentifiers

// MIME types
let mimeTextPlain = "text/plain"
let mimeTextHtml = "text/html"

// UT (Uniform Type) identifiers
let utTypeTextPlain = "public.text"
let utTypeTextHtml = "public.html"
let utTypeTextRtf = "public.rtf"

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
            result("iOS " + UIDevice.current.systemVersion) // Return iOS version
        case "getClipboardText":
            getClipboardText(result: result) // Get clipboard text
        case "setClipboardText":
            setClipboardText(call: call, result: result) // Set clipboard text
        default:
            result(FlutterMethodNotImplemented) // Method not implemented
        }
    }
    
    // Retrieve text from the clipboard
    private func getClipboardText(result: @escaping FlutterResult) {
        let board = UIPasteboard.general
        if let htmlData = board.data(forPasteboardType: utTypeTextHtml) {
            let html = String(data: htmlData, encoding: .utf8)
            result(html) // Return HTML text
            return
        } else if let rtfData = board.data(forPasteboardType: utTypeTextRtf) {
            do {
                let rtfAttrString = try NSAttributedString(data: rtfData, documentAttributes: nil)
                let htmlData = try rtfAttrString.data(from: NSRange(location: 0, length: rtfAttrString.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.html])
                result(String(data: htmlData, encoding: .utf8)) // Convert RTF to HTML and return
                return
            } catch {
                result(nil) // Error occurred while converting RTF to HTML
                return
            }
        } else if let plainData = board.string {
            result(plainData) // Return plain text
            return
        }

        result(nil) // No clipboard content found
    }
    
    // Set text in the clipboard
    private func setClipboardText(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let board = UIPasteboard.general
        board.items = [[:]] // Clear clipboard items
        
        if let html = call.arguments as? String {
            board.items[0][utTypeTextHtml] = html.data(using: .utf8) // Set clipboard content as HTML
        }
        
        result(nil) // Completion
    }
}
