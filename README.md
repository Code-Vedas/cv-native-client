# VK Native Client

Flutter plugin for VK Native Client.
This plugin allows you to access Native API's of platform.

## Usage

To use this plugin, add `vk_native_client` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  vk_native_client: ^0.0.2
```

### Example

```dart
import 'package:vk_native_client/vk_native_client.dart';

// Get platform version
String platformVersion = await VkNativeClient().getPlatformVersion();

// Get clipboard text
String clipboardText = await VkNativeClient().getClipboardText();

// Set clipboard text

await VkNativeClient().setClipboardText('Hello, world!');
```
