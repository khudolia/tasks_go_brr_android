import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  hideKeyboard() => SystemChannels.textInput.invokeMethod('TextInput.hide');

  unfocus() {
    hideKeyboard();
    FocusScope.of(context).unfocus();
  }
}