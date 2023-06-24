import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vk_native_client/vk_native_client_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelVkNativeClient platform = MethodChannelVkNativeClient();
  const MethodChannel channel = MethodChannel('vk_native_client');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return <String, String>{
          'plainText': '42',
          'htmlText': '<p>42</p>',
        };
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getClipboardData', () async {
    expect((await platform.getClipboardData())!['plainText'], '42');
    expect((await platform.getClipboardData())!['htmlText'], '<p>42</p>');
  });
}
