import 'package:flutter/material.dart';

/// A class that represents the data that can be copied to the clipboard.
@immutable
final class VkClipboardData {
  /// Constructs a [VkClipboardData].
  ///
  /// Parameters:
  /// - [plainText]: The plain text to copy to the clipboard.
  /// - [htmlText]: The HTML text to copy to the clipboard.
  const VkClipboardData({
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
enum VKClipboardMimeType {
  /// Plain text.
  plainText,

  /// HTML text.
  htmlText,
}
