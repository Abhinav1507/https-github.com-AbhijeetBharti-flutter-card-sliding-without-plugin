import 'package:flutter/material.dart';
import 'swipe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Swipe Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SwipeCard(),
    );
  }
}
