# VK Native Client

Flutter plugin for VK Native Client.
This plugin allows you to access Native API's of platform.

## Usage

To use this plugin, add `vk_native_client` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  vk_native_client: ^0.0.6
```

### Example

```dart
import 'package:vk_native_client/vk_native_client.dart';

// Get platform version
String platformVersion = await VkNativeClient.getPlatformVersion();

// Get clipboard data mime types
final List<VKClipboardMimeType> mimeTypes = await VkNativeClient.getClipboardDataMimeTypes();
log('Clipboard mime types: $mimeTypes');

// Get clipboard Data
final VkClipboardData? clipboardData = await VkNativeClient.getClipboardData();
log('Clipboard text: ${clipboardData?.plainText}');
log('Clipboard html: ${clipboardData?.htmlText}');

// Set clipboard Data
await VkNativeClient.setClipboardData(VkClipboardData(plainText: 'Hello World!', htmlText: '<b>Hello World!</b>'));
```
