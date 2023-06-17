// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
@js.JS()

import 'dart:html' as html show window, Blob;
import 'dart:typed_data' as typed_data show ByteBuffer;
import 'package:js/js.dart' as js show JS, staticInterop;
import 'dart:js_util' as js_util show callMethod, getProperty, promiseToFuture;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'vk_native_client_platform_interface.dart';

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

@js.JS()
@js.staticInterop
class ClipboardItem {
  external factory ClipboardItem(dynamic items);
}

extension ClipboardExtension on Clipboard {
  Future<Iterable<ClipboardItem>> read() async {
    final Future<Iterable<dynamic>> items = js_util.promiseToFuture(js_util.callMethod(this, 'read', []));
    return (await items).cast<ClipboardItem>();
  }

  Future<void> write(Iterable<ClipboardItem> data) => js_util.promiseToFuture(js_util.callMethod(this, 'write', [data.toList(growable: false)]));
}

extension BlobExt on html.Blob {
  Future<String?> text() => js_util.promiseToFuture(js_util.callMethod(this, 'text', []));
  Future<typed_data.ByteBuffer?> arrayBuffer() => js_util.promiseToFuture(js_util.callMethod(this, 'arrayBuffer', []));
}

extension ClipboardItemExtension on ClipboardItem {
  // One day... (right now no browser seem to support this)
  // static ClipboardItem createDelayed(
  //   dynamic items,
  // ) =>
  //     js_util.callMethod(ClipboardItem, 'createDelayed', [items]);

  Iterable<String> get types => (js_util.getProperty(this, 'types') as Iterable).cast<String>();
  Future<html.Blob> getType(String type) => js_util.promiseToFuture(js_util.callMethod(this, 'getType', [type]));
}

/// A web implementation of the VkNativeClientPlatform of the VkNativeClient plugin.
class VkNativeClientWeb extends VkNativeClientPlatform {
  /// Constructs a VkNativeClientWeb
  VkNativeClientWeb();

  static void registerWith(Registrar registrar) {
    VkNativeClientPlatform.instance = VkNativeClientWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  /// Returns a [String] containing the text from the clipboard.
  @override
  Future<String?> getClipboardText() async {
    /// Read raw clipboard text from the DOM.
    final Future<Iterable<dynamic>> items = js_util.promiseToFuture(js_util.callMethod(this, 'read', []));
    final Iterable<ClipboardItem> content = (await items).cast<ClipboardItem>();
    for (final ClipboardItem item in content) {
      final html.Blob blob = await item.getType('text/html');
      return await blob.text();
    }
    return null;
  }

  /// Sets the clipboard text to the provided [text].
  @override
  Future<bool> setClipboardText(String text) async {
    /// Write raw clipboard text to the DOM.
    final clipboard = js_util.getProperty(html.window.navigator, 'clipboard') as Clipboard;
    final items = <ClipboardItem>[
      ClipboardItem(<String, dynamic>{
        'text/html': text,
      }),
    ];
    await clipboard.write(items);
    return true;
  }

  /// Returns a [bool] indicating whether their is text on the clipboard.
  @override
  Future<bool> canCopyFromClipboard() async {
    /// Check if the clipboard is empty.
    final Future<Iterable<dynamic>> items = js_util.promiseToFuture(js_util.callMethod(this, 'read', []));
    final Iterable<ClipboardItem> content = (await items).cast<ClipboardItem>();
    for (final ClipboardItem item in content) {
      final html.Blob blob = await item.getType('text/html');
      return await blob.text() != null;
    }
    return false;
  }

  Clipboard getClipboard() {
    return js_util.getProperty(html.window.navigator, 'clipboard') as Clipboard;
  }
}
