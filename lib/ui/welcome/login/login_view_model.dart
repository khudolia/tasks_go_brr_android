import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/repositories/remote/user_info_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/authentication.dart';
import 'package:simple_todo_flutter/data/models/user_info/user_info.dart' as usr;
import 'package:simple_todo_flutter/utils/links.dart';

class LoginViewModel {
  UserInfoRepository _repo = UserInfoRepository();

  Future authUser(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null)
      Routes.toMainPage(context);
    else
      await loginWithGoogle(context);
  }

  loginWithGoogle(BuildContext context) async {
    User? user = await Authentication.signInWithGoogle(context: context);

    if (user != null) {
      addUserInfo(user);
      Routes.toMainPage(context);
    }
  }

  addUserInfo(User user) {
    _repo.addUserInfo(usr.UserInfo(
        id: user.uid,
        email: user.email,
        name: user.displayName,
        photoURL: user.photoURL));
  }

  openPrivacyPolicy() async {
    await Links.openLink(AppInfo.URL_PRIVACY_POLICY);
  }
}