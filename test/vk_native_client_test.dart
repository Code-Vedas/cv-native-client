import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vk_native_client/vk_native_client.dart';
import 'package:vk_native_client/vk_native_client_method_channel.dart';
import 'package:vk_native_client/vk_native_client_platform_interface.dart';

class MockVkNativeClientPlatform with MockPlatformInterfaceMixin implements VkNativeClientPlatform {
  @override
  Future<String?> getPlatformVersion() => Future<String?>.value('42');

  @override
  Future<Map<String, String>?> getClipboardText() => Future<Map<String, String>?>.value(<String, String>{'plainText': 'text', 'htmlText': '<p>text</p>'});

  @override
  Future<bool> setClipboardText(Map<String, String> params) => Future<bool>.value(true);

  @override
  Future<bool> canCopyFromClipboard() => Future<bool>.value(true);
}

void main() {
  final VkNativeClientPlatform initialPlatform = VkNativeClientPlatform.instance;

  test('$MethodChannelVkNativeClient is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVkNativeClient>());
  });

  test('getPlatformVersion', () async {
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await VkNativeClient.getPlatformVersion(), '42');
  });

  test('getClipboardText', () async {
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect((await VkNativeClient.getClipboardText())!.plainText, 'text');
    expect((await VkNativeClient.getClipboardText())!.htmlText, '<p>text</p>');
  });

  test('setClipboardText', () async {
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await VkNativeClient.setClipboardText(plainText: 'text', htmlText: '<div>text</div>'), true);
  });

  test('canCopyFromClipboard', () async {
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await VkNativeClient.canCopyFromClipboard(), true);
  });
}
