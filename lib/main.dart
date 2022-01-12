import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() async {
  runApp(const MyApp());
  TimerStream('hi', const Duration(seconds: 10)).listen((i) => print(i));
}

class MyStream {
  int counter = 0;
  StreamController<int> counterController = StreamController<int>();
  Stream<int> get counterStream => counterController.stream;

  void increment() {
    counter += 1;
    counterController.sink.add(counter);
  }

  void dispose() {
    counterController.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MyStream _myStream = MyStream();

  @override
  void dispose() {
    _myStream.dispose();
    super.dispose();
  }

  Stream<double> getRandomValues() async* {
    var random = Random(2);
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<Object>(
                stream: _myStream.counterStream,
                builder: (context, snapshot) => Text(
                      snapshot.hasData ? '${snapshot.data}' : '0',
                      style: Theme.of(context).textTheme.headline4,
                    )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _myStream.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
