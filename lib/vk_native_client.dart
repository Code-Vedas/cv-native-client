import 'data/data.dart';
import 'vk_native_client_platform_interface.dart';
export 'data/data.dart';

// ignore: avoid_classes_with_only_static_members
final class VkNativeClient {
  static Future<String?> getPlatformVersion() {
    return VkNativeClientPlatform.instance.getPlatformVersion();
  }

  static Future<VkClipboardData?> getClipboardText() async {
    final Map<String, String>? data = await VkNativeClientPlatform.instance.getClipboardText();
    if (data == null) {
      return null;
    }
    return VkClipboardData(
      plainText: data['plainText'] ?? '',
      htmlText: data['htmlText'] ?? '',
    );
  }

  static Future<bool> setClipboardText({required String plainText, required String htmlText}) {
    return VkNativeClientPlatform.instance.setClipboardText(
      <String, String>{
        'plainText': plainText,
        'htmlText': htmlText,
      },
    );
  }

  static Future<bool> canCopyFromClipboard() {
    return VkNativeClientPlatform.instance.canCopyFromClipboard();
  }
}
