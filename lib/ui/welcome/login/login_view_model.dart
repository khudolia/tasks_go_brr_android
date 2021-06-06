import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/authentication.dart';

class LoginViewModel {

  loginWithGoogle(BuildContext context) async {
    User? user = await Authentication.signInWithGoogle(context: context);
    if (user != null) {
      Routes.toMainPage(context);
    }
  }
}