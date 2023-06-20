// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
@js.JS()

import 'dart:html' as html show window, Blob;
import 'dart:typed_data' as typed_data show ByteBuffer;

import 'package:js/js.dart' as js show JS, staticInterop;
import 'package:js/js_util.dart' as js_util show jsify, callMethod, getProperty, promiseToFuture;

@js.JS()
@js.staticInterop
class EventTarget {
  external factory EventTarget();
}

@js.JS()
@js.staticInterop
class Clipboard implements EventTarget {
  external factory Clipboard();
}

extension ClipboardExtension on Clipboard {
  Future<Iterable<ClipboardItem>> read() async {
    final Future<Iterable<dynamic>> items = js_util.promiseToFuture(js_util.callMethod(this, 'read', <Object?>[]));
    return (await items).cast<ClipboardItem>();
  }

  Future<void> write(Iterable<ClipboardItem> data) => js_util.promiseToFuture(js_util.callMethod(this, 'write', <Object?>[data.toList(growable: false)]));
}

Clipboard getClipboard() {
  return js_util.getProperty(html.window.navigator, 'clipboard') as Clipboard;
}

@js.JS()
@js.staticInterop
class ClipboardItem {
  external factory ClipboardItem(dynamic items);
}

extension BlobExt on html.Blob {
  Future<String?> text() => js_util.promiseToFuture(js_util.callMethod(this, 'text', <Object?>[]));
  Future<typed_data.ByteBuffer?> arrayBuffer() => js_util.promiseToFuture(js_util.callMethod(this, 'arrayBuffer', <Object?>[]));
}

extension ClipboardItemExtension on ClipboardItem {
  Iterable<String> get types => (js_util.getProperty(this, 'types') as Iterable<dynamic>).cast<String>();
  Future<html.Blob> getType(String type) => js_util.promiseToFuture(js_util.callMethod(this, 'getType', <Object?>[type]));
}

// ignore: avoid_classes_with_only_static_members
final class ClipboardWeb {
  static bool detectClipboardApi() {
    final Clipboard clipboard = getClipboard();
    if (clipboard == null) {
      return false;
    }
    for (final String methodName in <String>['read', 'write']) {
      final dynamic method = js_util.getProperty(clipboard, methodName);
      if (method == null) {
        return false;
      }
    }

    return true;
  }

  static Future<Map<String, String>?> getClipboardText() async {
    /// Read raw clipboard text from the DOM.
    final Clipboard clipboard = getClipboard();
    final Iterable<ClipboardItem> content = await clipboard.read();
    if (content.isEmpty) {
      return null;
    }
    final Map<String, String> result = <String, String>{};
    for (final ClipboardItem item in content) {
      if (item.types.contains('text/plain')) {
        result['plainText'] = (await item.getType('text/plain')).text() as String;
      } else if (item.types.contains('text/html')) {
        result['htmlText'] = (await item.getType('text/html')).text() as String;
      }
    }
    return result;
  }

  static Future<bool> setClipboardText(Map<String, String> params) async {
    /// Write raw clipboard text to the DOM.
    final Clipboard clipboard = getClipboard();
    final Map<String, dynamic> representations = <String, html.Blob>{};
    if (params.containsKey('plainText')) {
      representations['text/plain'] = html.Blob(<dynamic>[params['plainText']], 'text/plain');
    }
    if (params.containsKey('htmlText')) {
      representations['text/html'] = html.Blob(<dynamic>[params['htmlText']], 'text/html');
    }
    if (representations.isNotEmpty) {
      await clipboard.write(<ClipboardItem>[ClipboardItem(js_util.jsify(representations))]);
      return true;
    }
    return false;
  }

  static Future<bool> canCopyFromClipboard() async {
    /// Check if the clipboard is empty.
    final Clipboard clipboard = getClipboard();
    final Iterable<ClipboardItem> content = await clipboard.read();
    for (final ClipboardItem item in content) {
      if (item.types.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
