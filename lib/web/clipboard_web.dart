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

/// In order to *not* need this ignore, consider extracting the "web" version
/// of your plugin as a separate package, instead of inlining it in the same
/// package as the core of your plugin.
/// ignore: avoid_web_libraries_in_flutter
@js.JS()

import 'dart:html' as html show window, Blob;
import 'dart:typed_data' as typed_data show ByteBuffer;

import 'package:js/js.dart' as js show JS, staticInterop;
import 'package:js/js_util.dart' as js_util
    show jsify, callMethod, getProperty, promiseToFuture;

/// Represents an event target.
@js.JS()
@js.staticInterop
class EventTarget {
  external factory EventTarget();
}

/// Represents a clipboard.
@js.JS()
@js.staticInterop
class Clipboard implements EventTarget {
  external factory Clipboard();
}

/// Extension methods for the [Clipboard] class.
extension ClipboardExtension on Clipboard {
  /// Reads the clipboard items asynchronously.
  ///
  /// Returns:
  /// - a [Future] that completes with an [Iterable] of [ClipboardItem]s if the read operation was successful,
  /// - a [Future] that completes with an empty [Iterable] if the clipboard is empty,
  /// - a [Future] that completes with `null` if the read operation failed or the clipboard is unsupported.
  Future<Iterable<ClipboardItem>> read() async {
    final Future<Iterable<dynamic>> items =
        js_util.promiseToFuture(js_util.callMethod(this, 'read', <Object?>[]));
    return (await items).cast<ClipboardItem>();
  }

  /// Writes the given [data] to the clipboard asynchronously.
  ///
  /// Returns:
  /// - a [Future] that completes with `null` if the write operation was successful,
  /// - a [Future] that completes with an error if the write operation failed or the clipboard is unsupported.
  /// - a [Future] that completes with an error if the write operation failed or the clipboard is unsupported.
  Future<void> write(Iterable<ClipboardItem> data) =>
      js_util.promiseToFuture(js_util
          .callMethod(this, 'write', <Object?>[data.toList(growable: false)]));
}

/// Returns the clipboard instance.
///
/// Returns:
/// - a [Clipboard] instance if the clipboard API is supported,
/// - `null` if the clipboard API is not supported.
Clipboard getClipboard() {
  return js_util.getProperty(html.window.navigator, 'clipboard') as Clipboard;
}

/// Represents a clipboard item.
@js.JS()
@js.staticInterop
class ClipboardItem {
  /// Creates a new instance of the [ClipboardItem] class.
  external factory ClipboardItem(dynamic items);
}

/// Extension methods for the [html.Blob] class.
extension BlobExt on html.Blob {
  /// Reads the content of the blob as text asynchronously.
  ///
  /// Returns:
  /// - a [Future] that completes with the text of the blob if the read operation was successful,
  /// - a [Future] that completes with `null` if the read operation failed.
  Future<String?> text() =>
      js_util.promiseToFuture(js_util.callMethod(this, 'text', <Object?>[]));

  /// Reads the content of the blob as an array buffer asynchronously.
  ///
  /// Returns:
  /// - a [Future] that completes with the array buffer of the blob if the read operation was successful,
  /// - a [Future] that completes with `null` if the read operation failed.
  Future<typed_data.ByteBuffer?> arrayBuffer() => js_util
      .promiseToFuture(js_util.callMethod(this, 'arrayBuffer', <Object?>[]));
}

/// Extension methods for the [ClipboardItem] class.
extension ClipboardItemExtension on ClipboardItem {
  /// Gets the types of the clipboard item.
  ///
  /// Returns:
  /// - an [Iterable] of [String]s containing the types of the clipboard item.
  Iterable<String> get types =>
      (js_util.getProperty(this, 'types') as Iterable<dynamic>).cast<String>();

  /// Gets the clipboard item of the specified [type].
  ///
  /// Returns:
  /// - a [Future] that completes with the clipboard item of the specified [type] if the read operation was successful,
  /// - a [Future] that completes with `null` if the read operation failed.
  Future<html.Blob?> getType(String type) => js_util
      .promiseToFuture(js_util.callMethod(this, 'getType', <Object?>[type]));
}

// ignore: avoid_classes_with_only_static_members
/// Represents the web version of the clipboard.
///
/// This class provides clipboard functionality for web applications.
///
/// In order to avoid the need for the `ignore` directive, it is recommended to extract the "web" version
/// of your plugin as a separate package, instead of inlining it in the same package as the core of your plugin.
final class ClipboardWeb {
  /// Determines if the clipboard API is available in the current browser.
  ///
  /// ```dart
  /// bool isClipboardSupported = ClipboardWeb.detectClipboardApi();
  /// ```
  ///
  /// Returns:
  /// - `true` if the clipboard API is available in the current browser,
  /// - `false` if the clipboard API is not available in the current browser.
  static bool detectClipboardApi() {
    final Clipboard clipboard = getClipboard();
    for (final String methodName in <String>['read', 'write']) {
      final dynamic method = js_util.getProperty(clipboard, methodName);
      if (method == null) {
        return false;
      }
    }

    return true;
  }

  /// Retrieves the plain text and HTML text content from the clipboard asynchronously.
  ///
  /// ```dart
  /// Future<Map<String, String>?> clipboardContent = ClipboardWeb.getClipboardData();
  /// clipboardContent.then((content) {
  ///   if (content != null) {
  ///     String plainText = content['plainText'];
  ///     String htmlText = content['htmlText'];
  ///     // Process the clipboard content
  ///   } else {
  ///     // Clipboard is empty or unsupported
  ///   }
  /// });
  /// ```
  ///
  /// Returns:
  /// - a [Future] that completes with a [Map] containing the plain text and HTML text content from the clipboard if the read operation was successful,
  /// - a [Future] that completes with `null` if the clipboard is empty or unsupported.
  static Future<Map<String, String>?> getClipboardData() async {
    final Clipboard clipboard = getClipboard();
    final Iterable<ClipboardItem> content = await clipboard.read();
    if (content.isEmpty) {
      /// Clipboard is empty, return null.
      return null;
    }
    final Map<String, String> result = <String, String>{};
    for (final ClipboardItem item in content) {
      if (item.types.contains('text/plain')) {
        /// Read the plain text.
        final html.Blob? blob = await item.getType('text/plain');
        if (blob == null) {
          /// Failed to read the plain text, continue.
          continue;
        }
        result['plainText'] = (await blob.text()) ?? '';
      }
      if (item.types.contains('text/html')) {
        /// Read the HTML text.
        final html.Blob? blob = await item.getType('text/html');
        if (blob == null) {
          /// Failed to read the HTML text, continue.
          continue;
        }
        result['htmlText'] = (await blob.text()) ?? '';
      }
    }

    /// Return the clipboard content.
    return result;
  }

  /// Writes the specified [params] to the clipboard asynchronously.
  ///
  /// ```dart
  /// Map<String, String> params = {
  ///   'plainText': 'Hello, world!',
  ///   'htmlText': '<p>Hello, world!</p>',
  /// };
  /// Future<bool> success = ClipboardWeb.setClipboardData(params);
  /// success.then((value) {
  ///   if (value) {
  ///     // Clipboard write operation succeeded
  ///   } else {
  ///     // Clipboard write operation failed or clipboard is unsupported
  ///   }
  /// });
  /// ```
  ///
  /// Parameters:
  /// - [params] - a [Map] containing the plain text and HTML text content to write to the clipboard.
  ///
  /// Returns:
  /// - a [Future] that completes with `true` if the write operation was successful,
  /// - a [Future] that completes with `false` if the write operation failed or the clipboard is unsupported.
  static Future<bool> setClipboardData(Map<String, String> params) async {
    final Clipboard clipboard = getClipboard();
    final Map<String, dynamic> representations = <String, html.Blob>{};
    if (params.containsKey('plainText')) {
      /// Write the plain text.
      representations['text/plain'] =
          html.Blob(<dynamic>[params['plainText']], 'text/plain');
    }
    if (params.containsKey('htmlText')) {
      /// Write the HTML text.
      representations['text/html'] =
          html.Blob(<dynamic>[params['htmlText']], 'text/html');
    }
    if (representations.isNotEmpty) {
      /// Write the clipboard content.
      await clipboard.write(
          <ClipboardItem>[ClipboardItem(js_util.jsify(representations))]);
      return true;
    }

    /// Failed to write the clipboard content, return false.
    return false;
  }

  /// Retrieves the mime types of the content currently available in the clipboard asynchronously.
  ///
  /// ```dart
  /// Future<List<String>> mimeTypes = ClipboardWeb.getClipboardDataMimeTypes();
  /// mimeTypes.then((types) {
  ///   if (types.isNotEmpty) {
  ///     // Clipboard has content with the specified mime types
  ///   } else {
  ///     // Clipboard is empty or unsupported
  ///   }
  /// });
  /// ```
  ///
  /// Retruns:
  /// - a [Future] that completes with a [List] of mime types if the read operation was successful,
  /// - a [Future] that completes with an empty [List] if the clipboard is empty or unsupported.
  static Future<List<String>> getClipboardDataMimeTypes() async {
    final List<String> mimeTypes = <String>[];
    final Clipboard clipboard = getClipboard();
    final Iterable<ClipboardItem> content = await clipboard.read();
    if (content.isEmpty) {
      /// Clipboard is empty, return an empty list.
      return mimeTypes;
    }
    for (final ClipboardItem item in content) {
      if (item.types.contains('text/plain')) {
        final html.Blob? blob = await item.getType('text/plain');
        if (blob == null) {
          /// Failed to read the plain text, continue.
          continue;
        }

        /// Add the plain text mime type.
        mimeTypes.add('plainText');
      }
      if (item.types.contains('text/html')) {
        final html.Blob? blob = await item.getType('text/html');
        if (blob == null) {
          /// Failed to read the HTML text, continue.
          continue;
        }

        /// Add the HTML text mime type.
        mimeTypes.add('htmlText');
      }
    }

    /// Return the mime types.
    return mimeTypes;
  }
}
