// ignore_for_file: avoid_classes_with_only_static_members

import 'data/data.dart';
import 'vk_native_client_platform_interface.dart';
export 'data/data.dart';

/// API for interacting with the clipboard.
///
/// This class implements the similar API as the [Clipboard] class in `package:flutter/services.dart`.
/// The difference is that this class supports both plain text and html text.
abstract final class VkNativeClient {
  /// Retrieves the clipboard data asynchronously.
  ///
  /// Returns:
  /// - Future<VkClipboardData?>: a [VkClipboardData] containing the clipboard data.
  static Future<VkClipboardData?> getClipboardData() async {
    /// Read raw clipboard data from the platform.
    final Map<String, String>? data = await VkNativeClientPlatform.instance.getClipboardData();
    if (data == null) {
      /// Return null if clipboard is empty or unsupported.
      return null;
    }

    /// Construct VkClipboardData from the raw clipboard data, and return it.
    return VkClipboardData(
      plainText: data['plainText'] ?? '',
      htmlText: data['htmlText'] ?? '',
    );
  }

  /// Writes the provided [data] to the clipboard asynchronously.
  ///
  /// Parameters:
  /// - data: [VkClipboardData] containing the clipboard data.
  ///
  /// Returns:
  /// - Future<bool>: [bool] indicating whether the clipboard write was successful.
  static Future<bool> setClipboardData(VkClipboardData data) async {
    /// Write raw clipboard data to the platform, and return the result.
    return VkNativeClientPlatform.instance.setClipboardData(
      <String, String>{
        'plainText': data.plainText,
        'htmlText': data.htmlText,
      },
    );
  }

  /// Retrieves the mime types of the content currently available in the clipboard asynchronously.
  ///
  /// Returns:
  /// - Future<List<VKClipboardMimeType>>: [List] of [VKClipboardMimeType]s containing the mime
  /// types of the content currently available in the clipboard.
  static Future<List<VKClipboardMimeType>> getClipboardDataMimeTypes() async {
    /// Read raw clipboard mime types from the platform.
    final List<String> mimeTypes = await VkNativeClientPlatform.instance.getClipboardDataMimeTypes();

    /// Convert the raw mime types to VKClipboardMimeType, and return it.
    return mimeTypes
        .map((String mimeType) {
          switch (mimeType) {
            case 'plainText':
              return VKClipboardMimeType.plainText;
            case 'htmlText':
              return VKClipboardMimeType.htmlText;
            default:
              return null;
          }
        })
        .whereType<VKClipboardMimeType>() // remove nulls
        .toList();
  }
}
