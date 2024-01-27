# CV Native Client

Flutter plugin for CV Native Client.
This plugin allows you to access Native API's of platform.

## Usage

To use this plugin, add `cv_native_client` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  cv_native_client: ^1.0.1
```

### Example

```dart
import 'package:cv_native_client/cv_native_client.dart';

// Get platform version
String platformVersion = await CvNativeClient.getPlatformVersion();

// Get clipboard data mime types
final List<CvClipboardMimeType> mimeTypes = await CvNativeClient.getClipboardDataMimeTypes();
log('Clipboard mime types: $mimeTypes');

// Get clipboard Data
final CvClipboardData? clipboardData = await CvNativeClient.getClipboardData();
log('Clipboard text: ${clipboardData?.plainText}');
log('Clipboard html: ${clipboardData?.htmlText}');

// Set clipboard Data
await CvNativeClient.setClipboardData(CvClipboardData(plainText: 'Hello World!', htmlText: '<b>Hello World!</b>'));
```
