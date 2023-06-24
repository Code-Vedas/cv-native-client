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
import UIKit
import Flutter
import UniformTypeIdentifiers

/// ClipboardIOS class
public class ClipboardIOS {
    private static let utTypeTextPlain = "public.utf8-plain-text"
    private static let utTypeTextHtml = "public.html"
    private static let utTypeTextRtf = "public.rtf"
    
    /// get clipboard data as a map
    /// 
    /// Returns:
    /// - Map<String, String> - clipboard data
    ///     - "plainText" - plain text
    ///     - "htmlText" - html text
    static func getClipboardData()-> [String: String]? {
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
    
    /// set clipboard data from a map
    ///
    /// Parameters:
    /// - call: FlutterMethodCall - method call from Flutter
    ///
    /// Returns:
    /// - Bool - true if clipboard content is set
    static func setClipboardData(call: FlutterMethodCall) -> Bool {
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
    
    /// get clipboard data mime types
    ///
    /// Returns:
    /// - [String]? - array of mime types
    ///     - "plainText" - plain text
    ///     - "htmlText" - html text
    static func getClipboardDataMimeTypes() -> [String]? {
        let board = UIPasteboard.general
        var result = [String]()
        if board.string != nil {
            /// Clipboard contains plain text
            result.append("plainText")
        }
        if board.data(forPasteboardType: utTypeTextHtml) != nil {
            /// Clipboard contains html text
            result.append("htmlText")
        }
        if board.data(forPasteboardType: utTypeTextRtf) != nil {
            /// Clipboard contains rtf text, rtf will be converted to html
            /// so we add htmlText to result
            result.append("htmlText")
        }
        return result
    }
}
