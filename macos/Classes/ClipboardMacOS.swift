import Cocoa
import FlutterMacOS

// ClipboardMacOS class
public class ClipboardMacOS {
    
    // Set text in the clipboard
    static func setClipboardText(call: FlutterMethodCall) -> Bool {
        // Set HTML to clipboard, if not HTML, set plain text
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        
        // Get plainText and htmlText from call.arguments String,String map
        guard let map = call.arguments as? [String: String],
              let plainText = map["plainText"],
              let htmlText = map["htmlText"] else {
            return false // No clipboard content found
        }
        
        pasteboard.declareTypes([.html, .string], owner: nil)
        let isPlainTextSet = pasteboard.setString(plainText, forType: .string)
        let isHtmlTextSet = pasteboard.setString(htmlText, forType: .html)
        return isPlainTextSet && isHtmlTextSet // Return true if clipboard content is set
    }
    
    // Check if clipboard is available
    static func canCopyFromClipboard() -> Bool {
        let isText = NSPasteboard.general.data(forType: .string) != nil
        let isHtml = NSPasteboard.general.data(forType: .html) != nil
        let isRtf = NSPasteboard.general.data(forType: .rtf) != nil
        return isText || isHtml || isRtf // Return true if clipboard content found, false otherwise
    }
    
    // Retrieve text from the clipboard, return map with plainText and htmlText
    static func getClipboardText()-> [String: String]? {        // Initialize result map
        var result = [String: String]()
        // Get HTML from clipboard, if not HTML, return plain text
        let board = NSPasteboard.general
        
        if let html = board.string(forType: .html) ?? getRtfAsHtml() {
            result["htmlText"] = html // add htmlText to result map
        }
        if let text = board.string(forType: .string) {
            result["plainText"] = text // add plainText to result map
        }
        
        return result // Return result map
    }
    
    // Convert RTF data to HTML
    static func getRtfAsHtml() -> String? {
        guard let boardRtf = NSPasteboard.general.data(forType: .rtf),
              let attrStr = NSAttributedString(rtf: boardRtf, documentAttributes: nil),
              let htmlData = try? attrStr.data(from: NSRange(location: 0, length: attrStr.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.html]),
              let htmlString = String(data: htmlData, encoding: .utf8) else {
            return nil
        }
        return htmlString
    }
}
