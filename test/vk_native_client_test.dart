import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vk_native_client/vk_native_client.dart';
import 'package:vk_native_client/vk_native_client_method_channel.dart';
import 'package:vk_native_client/vk_native_client_platform_interface.dart';

class MockVkNativeClientPlatform with MockPlatformInterfaceMixin implements VkNativeClientPlatform {
  @override
  Future<Map<String, String>?> getClipboardData() => Future<Map<String, String>?>.value(<String, String>{'plainText': 'text', 'htmlText': '<p>text</p>'});

  @override
  Future<bool> setClipboardData(Map<String, String> params) => Future<bool>.value(true);

  @override
  Future<List<String>> getClipboardDataMimeTypes() => Future<List<String>>.value(<String>['plainText', 'htmlText']);
}

void main() {
  final VkNativeClientPlatform initialPlatform = VkNativeClientPlatform.instance;

  test('$MethodChannelVkNativeClient is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVkNativeClient>());
  });

  test('getClipboardData', () async {
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect((await VkNativeClient.getClipboardData())!.plainText, 'text');
    expect((await VkNativeClient.getClipboardData())!.htmlText, '<p>text</p>');
  });

  test('setClipboardData', () async {
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await VkNativeClient.setClipboardData(const VkClipboardData(plainText: 'text', htmlText: '<p>text</p>')), true);
  });

  test('getClipboardDataMimeTypes', () async {
    final MockVkNativeClientPlatform fakePlatform = MockVkNativeClientPlatform();
    VkNativeClientPlatform.instance = fakePlatform;

    expect(await VkNativeClient.getClipboardDataMimeTypes(), <VKClipboardMimeType>[VKClipboardMimeType.plainText, VKClipboardMimeType.htmlText]);
  });
}
