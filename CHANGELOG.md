## Change Log

## 0.0.6

- improved native implementation for Web, Android, iOS, macOS, Windows and Linux
- removed `canCopyFromClipboard` method
- added new method `getClipboardDataMimeTypes` to get mime types of clipboard content
  - mime types are returned as a list of 'VKClipboardMimeType' enum values
  - supported on Android, iOS, macOS, Windows and Linux
- removed `platformVersion` method

## 0.0.5

- added in-development note to readme
- made code public
- fix linting issues
- no real code changes

## 0.0.4

- Added support for 'canCopyFromClipboard` method
- Updated readme and example

## 0.0.3

- Fixed changelog
- no code changes

## 0.0.2

- Added readme
- no code changes

## 0.0.1

- Initial release
- API for getting and setting clipboard text
- API for getting platform version

### API Release Notes

```dart
class VkNativeClient {
  Future<String?> getPlatformVersion() {
    return VkNativeClientPlatform.instance.getPlatformVersion();
  }

  Future<String?> getClipboardData() {
    return VkNativeClientPlatform.instance.getClipboardData();
  }

  Future<bool> setClipboardData(String text) {
    return VkNativeClientPlatform.instance.setClipboardData(text);
  }
}
```
