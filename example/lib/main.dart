

import 'package:collection_box/collection_box.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collection Box',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Collection Box'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _currentCollection = [];
  void getList(List<String> collection) {
    _currentCollection = collection;
    debugPrint("some thing ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Spacer(flex: 1),
            CollectionBox(
              onCollectionChanged: getList,
              limit: 5,
            ),
            const Spacer(flex: 1),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  setState(() {});
                });
              },
              child: const Text("Check collection box length"),
            ),
            const Spacer(flex: 1),
            Text('Collection box length: ${_currentCollection.length}'),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
