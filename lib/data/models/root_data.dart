import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RootData extends ChangeNotifier {
  late BuildContext rootContext;

  int theme;

  RootData(this.theme);

  changeTheme(int theme) {
    this.theme = theme;

    notifyListeners();
  }

  setRootContext(BuildContext context) => rootContext = context;
}