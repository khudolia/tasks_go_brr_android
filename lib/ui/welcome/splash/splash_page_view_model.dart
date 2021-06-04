import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/repositories/profile_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/routes.dart';

class SplashPageViewModel {
  ProfileRepository _repProfile = ProfileRepository();
  AsyncMemoizer _memoizer = AsyncMemoizer();
  late String? _userId;

  Future<String?> getUserIdAsync() async {
    _userId = await _repProfile.getString(Profile.UUID_KEY);
    return _userId;
  }

  initializeData(BuildContext context) {
    return _memoizer.runOnce(() async {
      await Firebase.initializeApp();
      await getUserIdAsync();

      goToPage(context);
    });
  }

  goToPage(BuildContext context) {
    if(_userId == null || _userId!.isEmpty)
      Routes.toLoginPage(context);
    else
      Routes.toMainPage(context);
  }
}