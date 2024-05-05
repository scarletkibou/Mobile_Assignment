import 'package:flutter/material.dart';
import 'package:mobile_assignment/DisplayWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile_Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class FibonacciItem {
  final int value;
  final int index;

  FibonacciItem(this.value, this.index);
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  List<FibonacciItem> fibonacciListCreate(int count) {
    List<FibonacciItem> fibonacciList = [];
    int a = 0, b = 1;
    for (int i = 0; i < count; i++) {
      fibonacciList.add(FibonacciItem(a, i));
      int temp = a + b;
      a = b;
      b = temp;
    }
    return fibonacciList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Example')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DisplayWidget(fibonacciList: fibonacciListCreate(41)),
      ),
    );
  }
}
