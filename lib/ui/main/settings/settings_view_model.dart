import 'package:flutter/cupertino.dart';
import 'package:simple_todo_flutter/data/models/root_data.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/authentication.dart';
import 'package:provider/provider.dart';

class SettingsViewModel {

  logoutFromAccount(BuildContext context) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;
    if (await Authentication.signOut(context: context))
      Routes.toSplashPage(rootContext);
  }
}