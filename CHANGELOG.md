## 0.0.1

- Initial release

### API Release Notes

```dart
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
```
