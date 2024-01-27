import 'package:cv_native_client/cv_native_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> logs = <String>[];
  @override
  void initState() {
    super.initState();
    logs = <String>[];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CV Native Client Example App'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              // gap
              const SizedBox(height: 16),
              Wrap(
                runSpacing: 8.0,
                children: buttons,
              ),
              // gap
              const SizedBox(height: 16),
              // logs
              const Text('Logs:'),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // rest of the space
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: logs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(logs[(logs.length - 1) - index]);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get buttons {
    return <Widget>[
      ElevatedButton(
        onPressed: () async {
          final List<CvClipboardMimeType> mimeTypes = await CvNativeClient.getClipboardDataMimeTypes();
          logs.add('');
          logs.add('${DateTime.now()}: Clipboard mime types: $mimeTypes');
          setState(() {});
        },
        child: const Text('Get clipboard mime types'),
      ),
      // gap
      const SizedBox(width: 16),
      ElevatedButton(
        onPressed: () async {
          final CvClipboardData? clipboardData = await CvNativeClient.getClipboardData();
          logs.add('');
          logs.add('plainText: ${clipboardData?.plainText}');
          logs.add('htmlText: ${clipboardData?.htmlText}');
          logs.add('${DateTime.now()}: Clipboard data:');
          setState(() {});
        },
        child: const Text('Get clipboard text'),
      ),
      // gap
      const SizedBox(width: 16),
      ElevatedButton(
        onPressed: () async {
          const CvClipboardData data = CvClipboardData(
            plainText: 'Hello, world!',
            htmlText: '<p>Hello, world!</p>',
          );
          final bool result = await CvNativeClient.setClipboardData(data);
          logs.add('');
          logs.add('${DateTime.now()}: Clipboard set: $result');
          setState(() {});
        },
        child: const Text('Set "Hello, world!" to clipboard'),
      ),
      // gap
      const SizedBox(width: 16),
      // clear logs
      ElevatedButton(
        onPressed: () {
          logs.clear();
          setState(() {});
        },
        child: const Text('Clear logs'),
      ),
    ];
  }
}
