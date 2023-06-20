import UIKit
import Flutter
import UniformTypeIdentifiers

/// ClipboardIOS class
public class ClipboardIOS {
    private static let utTypeTextPlain = "public.utf8-plain-text"
    private static let utTypeTextHtml = "public.html"
    private static let utTypeTextRtf = "public.rtf"
    
    // Check if clipboard is available
    static func canCopyFromClipboard() -> Bool {
        let board = UIPasteboard.general
        let htmlData = board.data(forPasteboardType: utTypeTextHtml)
        let rtfData = board.data(forPasteboardType: utTypeTextRtf)
        let plainData = board.string
        return htmlData != nil || rtfData != nil || plainData != nil // Return true if clipboard is available
    }
    
    // Retrieve text from the clipboard, return map with plainText and htmlText
    static func getClipboardText()-> [String: String]? {
        let board = UIPasteboard.general
        // Initialize result map
        var result = [String: String]()
        if let htmlData = board.data(forPasteboardType: utTypeTextHtml) {
            result["htmlText"] = String(data: htmlData, encoding: .utf8) // add htmlText to result map
        } else if let rtfData = board.data(forPasteboardType: utTypeTextRtf) {
            do {
                let rtfAttrString = try NSAttributedString(data: rtfData, documentAttributes: nil)
                let htmlData = try rtfAttrString.data(from: NSRange(location: 0, length: rtfAttrString.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.html])
                result["htmlText"] = String(data: htmlData, encoding: .utf8) // add htmlText to result map
            } catch {
            }
        }
        if let plainData = board.string {
            result["plainText"] = plainData // add plainText to result map
        }
        return result // Return result map
    }
    
    // Set text in the clipboard
    static func setClipboardText(call: FlutterMethodCall) -> Bool {
        let pasteboard = UIPasteboard.general
        pasteboard.items = [[:]] // Clear clipboard items
        
        // Get plainText and htmlText from call.arguments String,String map
        guard let map = call.arguments as? [String: String],
              let plainText = map["plainText"],
              let htmlText = map["htmlText"] else {
            return false // No clipboard content found
        }
        pasteboard.string = plainText
        pasteboard.items[0][utTypeTextHtml] = htmlText.data(using: .utf8)
        return true // Return true if clipboard content is set
    }
}
