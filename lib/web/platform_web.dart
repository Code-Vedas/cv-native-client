import 'dart:html' as html show window;

// ignore: avoid_classes_with_only_static_members
final class PlatformWeb {
  static String getPlatformVersion() {
    final String version = html.window.navigator.userAgent;
    return version;
  }
}
