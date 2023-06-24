> **Warning**
> This plugin is under development and not being tested throughly in every platform
> Use it with caution and please report any issues you find.

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

// Check if clipboard text can be copied
bool canCopyFromClipboard = await VkNativeClient.canCopyFromClipboard();
// Get clipboard text
final VkClipboardData? clipboardData = await VkNativeClient.getClipboardData();
log('Clipboard text: ${clipboardData?.plainText}');
log('Clipboard html: ${clipboardData?.htmlText}');

// Set clipboard text
await VkNativeClient.setClipboardData(plainText: 'text', htmlText: '<div>text</div>');
```
