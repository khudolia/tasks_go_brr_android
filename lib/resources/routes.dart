import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/main_page.dart';
import 'package:simple_todo_flutter/ui/welcome/login/login_page.dart';
import 'package:simple_todo_flutter/ui/welcome/splash/splash_page.dart';

abstract class Routes {
  static Future<dynamic> toSplashPage(BuildContext context) async {
    return await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SplashPage()),
    );
  }

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

  static dynamic back(BuildContext context, {dynamic result}) async {
    return Navigator.of(context).pop(result);
  }
}