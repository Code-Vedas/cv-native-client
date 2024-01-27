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
import 'package:flutter/material.dart';

/// A class that represents the data that can be copied to the clipboard.
@immutable
final class CvClipboardData {
  /// Constructs a [CvClipboardData].
  ///
  /// Parameters:
  /// - [plainText]: The plain text to copy to the clipboard.
  /// - [htmlText]: The HTML text to copy to the clipboard.
  const CvClipboardData({
    required this.plainText,
    required this.htmlText,
  });

  /// The plain text to copy to the clipboard.
  final String plainText;

  /// The HTML text to copy to the clipboard.
  final String htmlText;
}

/// An enum that represents the mime types of the content currently available in the clipboard.
///
/// - [plainText]: [String] containing the plain text from the clipboard.
/// - [htmlText]: [String] containing the html text from the clipboard.
enum CvClipboardMimeType {
  /// Plain text.
  plainText,

  /// HTML text.
  htmlText,
}
