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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
