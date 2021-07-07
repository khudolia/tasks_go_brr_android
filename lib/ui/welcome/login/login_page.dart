import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/ui/welcome/login/login_view_model.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel _model = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedGestureDetector(
            onTap: () async {
              _model.authUser(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: context.primary,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Text("action.log_in".tr()),
            )),
      ),
    );
  }
}
