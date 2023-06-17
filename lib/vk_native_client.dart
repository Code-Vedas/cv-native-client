import 'vk_native_client_platform_interface.dart';

class VkNativeClient {
  Future<String?> getPlatformVersion() {
    return VkNativeClientPlatform.instance.getPlatformVersion();
  }

  Future<String?> getClipboardText() {
    return VkNativeClientPlatform.instance.getClipboardText();
  }

  Future<bool> setClipboardText(String text) {
    return VkNativeClientPlatform.instance.setClipboardText(text);
  }
}
