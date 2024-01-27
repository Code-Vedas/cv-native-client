## Change Log

## 1.0.0

- Breaking change: namespace change from 'vk_cv_native_client' to 'cv_native_client'

## 0.0.9

- Fixed linting issues
- no real code changes

## 0.0.8

- Fixed linting issues
- no real code changes

## 0.0.7

- removed warning from README.md
- no code changes

## 0.0.6

- improved native implementation for Web, Android, iOS, macOS, Windows and Linux
- removed `canCopyFromClipboard` method
- added new method `getClipboardDataMimeTypes` to get mime types of clipboard content
  - mime types are returned as a list of 'CvClipboardMimeType' enum values
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
class CvNativeClient {
  Future<String?> getPlatformVersion() {
    return CvNativeClientPlatform.instance.getPlatformVersion();
  }

  Future<String?> getClipboardData() {
    return CvNativeClientPlatform.instance.getClipboardData();
  }

  Future<bool> setClipboardData(String text) {
    return CvNativeClientPlatform.instance.setClipboardData(text);
  }
}
```
