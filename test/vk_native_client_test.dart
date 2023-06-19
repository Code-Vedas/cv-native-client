import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vk_native_client/vk_native_client.dart';
import 'package:vk_native_client/vk_native_client_method_channel.dart';
import 'package:vk_native_client/vk_native_client_platform_interface.dart';

class MockVkNativeClientPlatform with MockPlatformInterfaceMixin implements VkNativeClientPlatform {
  @override
  Future<String?> getPlatformVersion() => Future<String?>.value('42');

  @override
  Future<String?> getClipboardText() => Future<String?>.value('text');

  @override
  Future<bool> setClipboardText(String text) => Future<bool>.value(true);

  @override
  Future<bool> canCopyFromClipboard() => Future<bool>.value(true);
}

void main() {
  final VkNativeClientPlatform initialPlatform = VkNativeClientPlatform.instance;

  test('$MethodChannelVkNativeClient is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVkNativeClient>());
  });

  test('getPlatformVersion', () async {
    final VkNativeClient vkNativeClientPlugin = VkNativeClient();
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await vkNativeClientPlugin.getPlatformVersion(), '42');
  });

  test('getClipboardText', () async {
    final VkNativeClient vkNativeClientPlugin = VkNativeClient();
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await vkNativeClientPlugin.getClipboardText(), 'text');
  });

  test('setClipboardText', () async {
    final VkNativeClient vkNativeClientPlugin = VkNativeClient();
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await vkNativeClientPlugin.setClipboardText('text'), true);
  });

  test('canCopyFromClipboard', () async {
    final VkNativeClient vkNativeClientPlugin = VkNativeClient();
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await vkNativeClientPlugin.canCopyFromClipboard(), true);
  });
}
