import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vk_native_client/vk_native_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await VkNativeClient.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: () async {
                  if (await VkNativeClient.canCopyFromClipboard()) {
                    final VkClipboardData? clipboardData = await VkNativeClient.getClipboardText();
                    log('Clipboard text: ${clipboardData?.plainText}');
                    log('Clipboard html: ${clipboardData?.htmlText}');
                  } else {
                    log('Clipboard is not available');
                  }
                },
                child: const Text('Get clipboard text'),
              ),
              // gap
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final bool result = await VkNativeClient.setClipboardText(plainText: 'Hello, world!', htmlText: '<h1>Hello, world!</h1>');
                  log('Clipboard text set: $result');
                },
                child: const Text('Set "Hello, world!" to clipboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
