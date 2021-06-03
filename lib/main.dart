import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/base/base_stateless_widget.dart';
import 'package:simple_todo_flutter/main_page.dart';

void main() {
  runApp(App());
}

class App extends BaseStatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}


