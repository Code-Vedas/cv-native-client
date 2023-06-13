
import 'vk_native_client_platform_interface.dart';

class VkNativeClient {
  Future<String?> getPlatformVersion() {
    return VkNativeClientPlatform.instance.getPlatformVersion();
  }
}
