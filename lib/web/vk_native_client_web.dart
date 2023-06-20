import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import '../vk_native_client_platform_interface.dart';
import 'clipboard_web.dart';
import 'platform_web.dart';

/// A web implementation of the VkNativeClientPlatform of the VkNativeClient plugin.
class VkNativeClientWeb extends VkNativeClientPlatform {
  /// Constructs a VkNativeClientWeb
  VkNativeClientWeb();

  static void registerWith(Registrar registrar) {
    if (!ClipboardWeb.detectClipboardApi()) {
      return;
    }
    VkNativeClientPlatform.instance = VkNativeClientWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    return PlatformWeb.getPlatformVersion();
  }

  /// Returns a [String] containing the text from the clipboard.
  @override
  Future<Map<String, String>?> getClipboardText() async {
    /// Read raw clipboard text from the DOM.
    return ClipboardWeb.getClipboardText();
  }

  /// Sets the clipboard text to the provided [text].
  @override
  Future<bool> setClipboardText(Map<String, String> params) async {
    /// Write raw clipboard text to the DOM.
    return ClipboardWeb.setClipboardText(params);
  }

  /// Returns a [bool] indicating whether their is text on the clipboard.
  @override
  Future<bool> canCopyFromClipboard() async {
    /// Check if the clipboard is empty.
    return ClipboardWeb.canCopyFromClipboard();
  }
}
