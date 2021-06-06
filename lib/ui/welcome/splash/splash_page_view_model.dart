import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/utils/authentication.dart';
import 'package:simple_todo_flutter/resources/routes.dart';

class SplashPageViewModel {
  AsyncMemoizer _memoizer = AsyncMemoizer();
  late User? _user;

  initializeData(BuildContext context) {
    return _memoizer.runOnce(() async {
      _user = await Authentication.initializeFirebase();

      goToPage(context);
    });
  }

  goToPage(BuildContext context) {
    if(_user == null)
      Routes.toLoginPage(context);
    else
      Routes.toMainPage(context);
  }
}