import 'package:flutter/material.dart';

class RegularlyPage extends StatefulWidget {
  const RegularlyPage({Key? key}) : super(key: key);

  @override
  _RegularlyPageState createState() => _RegularlyPageState();
}

class _RegularlyPageState extends State<RegularlyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text("Regularly"),
      ),
    );
  }
}
