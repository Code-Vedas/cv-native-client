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
import Cocoa
import FlutterMacOS

// ClipboardMacOS class
public class ClipboardMacOS {
    
    /// get clipboard data as a map
    /// 
    /// Returns:
    /// - Map<String, String> - clipboard data
    ///     - "plainText" - plain text
    ///     - "htmlText" - html text
    static func getClipboardData()-> [String: String]? {        
        // Initialize result map
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

    /// set clipboard data from a map
    ///
    /// Parameters:
    /// - call: FlutterMethodCall - method call from Flutter
    ///
    /// Returns:
    /// - Bool - true if clipboard content is set
    static func setClipboardData(call: FlutterMethodCall) -> Bool {
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
    
    /// get clipboard data mime types
    ///
    /// Returns:
    /// - [String]? - array of mime types
    ///     - "plainText" - plain text
    ///     - "htmlText" - html text
    static func getClipboardDataMimeTypes() -> [String]? {
        let board = NSPasteboard.general
        var result = [String]()
        if board.string(forType: .string) != nil {
            result.append("plainText")
        }
        if board.string(forType: .html) != nil || getRtfAsHtml() != nil {
            result.append("htmlText")
        }
        return result
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
