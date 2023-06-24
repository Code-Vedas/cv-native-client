import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vk_native_client_platform_interface.dart';

/// An implementation of [VkNativeClientPlatform] that uses method channels.
class MethodChannelVkNativeClient extends VkNativeClientPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('vk_native_client');

  /// get clipboard data from the clipboard asynchronously.
  ///
  /// Returns:
  /// - Future<Map<String, String>?>: a [Map] containing the clipboard data.
  ///   - 'plainText': [String] containing the plain text from the clipboard.
  ///   - 'htmlText': [String] containing the html text from the clipboard.
  @override
  Future<Map<String, String>?> getClipboardData() async {
    final Map<String, String>? text = await methodChannel.invokeMapMethod<String, String>('getClipboardData');
    return text;
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
    final bool? result = await methodChannel.invokeMethod<bool>('setClipboardData', params);
    return result ?? false;
  }

  /// Retrieves the mime types of the content currently available in the clipboard asynchronously.
  ///
  /// Returns:
  /// - Future<List<String>>: [List] of [String]s containing the mime types of the content currently available in the clipboard.
  ///   - 'plainText': [String] containing the plain text from the clipboard.
  ///   - 'htmlText': [String] containing the html text from the clipboard.
  @override
  Future<List<String>> getClipboardDataMimeTypes() async {
    final List<String>? mimeTypes = await methodChannel.invokeListMethod<String>('getClipboardDataMimeTypes');
    return mimeTypes ?? <String>[];
  }
}
