import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'vk_native_client_method_channel.dart';

abstract class VkNativeClientPlatform extends PlatformInterface {
  /// Constructs a VkNativeClientPlatform.
  VkNativeClientPlatform() : super(token: _token);

  static final Object _token = Object();

  static VkNativeClientPlatform _instance = MethodChannelVkNativeClient();

  /// The default instance of [VkNativeClientPlatform] to use.
  ///
  /// Defaults to [MethodChannelVkNativeClient].
  static VkNativeClientPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VkNativeClientPlatform] when
  /// they register themselves.
  static set instance(VkNativeClientPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// get clipboard data from the clipboard asynchronously.
  ///
  /// Returns:
  /// - Future<Map<String, String>?>: a [Map] containing the clipboard data.
  ///   - 'plainText': [String] containing the plain text from the clipboard.
  ///   - 'htmlText': [String] containing the html text from the clipboard.
  Future<Map<String, String>?> getClipboardData() async {
    throw UnimplementedError('getClipboardData() has not been implemented.');
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
  Future<bool> setClipboardData(Map<String, String> params) async {
    throw UnimplementedError('setClipboardData() has not been implemented.');
  }

  /// Retrieves the mime types of the content currently available in the clipboard asynchronously.
  ///
  /// Returns:
  /// - Future<List<String>>: [List] of [String]s containing the mime types of the content currently available in the clipboard.
  ///   - 'plainText': [String] containing the plain text from the clipboard.
  ///   - 'htmlText': [String] containing the html text from the clipboard.
  Future<List<String>> getClipboardDataMimeTypes() async {
    throw UnimplementedError('getAvailableMimeTypes() has not been implemented.');
  }
}
