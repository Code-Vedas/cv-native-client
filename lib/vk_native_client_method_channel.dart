import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vk_native_client_platform_interface.dart';

/// An implementation of [VkNativeClientPlatform] that uses method channels.
class MethodChannelVkNativeClient extends VkNativeClientPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('vk_native_client');

  @override
  Future<String?> getPlatformVersion() async {
    final String? version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<String, String>?> getClipboardText() async {
    final Map<String, String>? text = await methodChannel.invokeMapMethod<String, String>('getClipboardText');
    return text;
  }

  @override
  Future<bool> setClipboardText(Map<String, String> params) async {
    final bool? result = await methodChannel.invokeMethod<bool>('setClipboardText', params);
    return result ?? false;
  }

  @override
  Future<bool> canCopyFromClipboard() async {
    final bool? result = await methodChannel.invokeMethod<bool>('canCopyFromClipboard');
    return result ?? false;
  }
}
