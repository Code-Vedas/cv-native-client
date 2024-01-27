// MIT License
//
// Copyright (c) 2023 Code Vedas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:cv_native_client/cv_native_client.dart';
import 'package:cv_native_client/cv_native_client_method_channel.dart';
import 'package:cv_native_client/cv_native_client_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCvNativeClientPlatform
    with MockPlatformInterfaceMixin
    implements CvNativeClientPlatform {
  @override
  Future<Map<String, String>?> getClipboardData() =>
      Future<Map<String, String>?>.value(
          <String, String>{'plainText': 'text', 'htmlText': '<p>text</p>'});

  @override
  Future<bool> setClipboardData(Map<String, String> params) =>
      Future<bool>.value(true);

  @override
  Future<List<String>> getClipboardDataMimeTypes() =>
      Future<List<String>>.value(<String>['plainText', 'htmlText']);
}

void main() {
  final CvNativeClientPlatform initialPlatform =
      CvNativeClientPlatform.instance;

  test('$MethodChannelCvNativeClient is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCvNativeClient>());
  });

  test('getClipboardData', () async {
    final MockCvNativeClientPlatform fakePlatform =
        MockCvNativeClientPlatform();
    CvNativeClientPlatform.instance = fakePlatform;

    expect((await CvNativeClient.getClipboardData())!.plainText, 'text');
    expect((await CvNativeClient.getClipboardData())!.htmlText, '<p>text</p>');
  });

  test('setClipboardData', () async {
    final MockCvNativeClientPlatform fakePlatform =
        MockCvNativeClientPlatform();
    CvNativeClientPlatform.instance = fakePlatform;

    expect(
        await CvNativeClient.setClipboardData(
            const CvClipboardData(plainText: 'text', htmlText: '<p>text</p>')),
        true);
  });

  test('getClipboardDataMimeTypes', () async {
    final MockCvNativeClientPlatform fakePlatform =
        MockCvNativeClientPlatform();
    CvNativeClientPlatform.instance = fakePlatform;

    expect(
        await CvNativeClient.getClipboardDataMimeTypes(), <CvClipboardMimeType>[
      CvClipboardMimeType.plainText,
      CvClipboardMimeType.htmlText
    ]);
  });
}
