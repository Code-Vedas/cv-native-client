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

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../cv_native_client_platform_interface.dart';

/// Represents the default web implementation of the [CvNativeClientPlatform].
/// This class is instantiated when the web platform does not support the
///
/// clipboard API used in [ClipboardWeb].
class DefaultClipboardWeb extends CvNativeClientPlatform {
  static void registerWith(Registrar registrar) {
    CvNativeClientPlatform.instance = DefaultClipboardWeb();
  }

  /// get clipboard data from the clipboard asynchronously.
  ///
  /// Returns:
  /// - Future<Map<String, String>?>: a [Map] containing the clipboard data.
  ///   - 'plainText': [String] containing the plain text from the clipboard.
  ///   - 'htmlText': [String] containing the html text from the clipboard.
  @override
  Future<Map<String, String>?> getClipboardData() async {
    /// Read raw clipboard text from the DOM.
    final ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData == null) {
      /// Return null if clipboard is empty or unsupported.
      return null;
    }
    return <String, String>{
      'plainText': clipboardData.text ?? '',
      'htmlText': '', // since htmlText is not supported, return empty string.
    };
  }

  /// Writes the provided [text] to the clipboard asynchronously.
  ///
  /// Parameters:
  /// - params: [Map<String, String>] containing the clipboard data.
  ///   - 'plainText': [String] containing the plain text to write to the clipboard.
  ///   - 'htmlText': [String] containing the html text to write to the clipboard.
  ///
  /// Returns:
  /// - Future<bool>: [bool] indicating whether the clipboard write was successful.
  @override
  Future<bool> setClipboardData(Map<String, String> params) async {
    /// Write raw clipboard text to the DOM.
    if (params.containsKey('plainText')) {
      await Clipboard.setData(ClipboardData(text: params['plainText'] ?? ''));
      return true;
    }
    return false;
  }

  /// Retrieves the mime types of the content currently available in the clipboard asynchronously.
  ///
  /// Returns:
  /// - Future<List<String>>: [List] of [String]s containing the mime types of the content currently available in the clipboard.
  ///   - 'plainText': [String] containing the plain text from the clipboard.
  ///   - 'htmlText': [String] containing the html text from the clipboard.
  @override
  Future<List<String>> getClipboardDataMimeTypes() async {
    /// Read raw clipboard text mime types from the DOM.
    final ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData == null) {
      /// Return empty list if clipboard is empty or unsupported.
      return <String>[];
    }
    if (clipboardData.text != null) {
      /// Return plainText mime type if plainText is available.
      return <String>['plainText'];
    }

    /// Return empty list if clipboard is empty or unsupported.
    return <String>[];
  }
}
