import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/main_page.dart';
import 'package:simple_todo_flutter/ui/welcome/login_page.dart';

abstract class Routes {
  static Future<dynamic> toLoginPage(BuildContext context) async {
    return await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  static Future<dynamic> toMainPage(BuildContext context) async {
    return await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}