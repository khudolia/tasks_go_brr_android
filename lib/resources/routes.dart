import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/data/models/root_data.dart';
import 'package:simple_todo_flutter/data/models/task.dart';
import 'package:simple_todo_flutter/main_page.dart';
import 'package:simple_todo_flutter/ui/task/task_edit_page.dart';
import 'package:simple_todo_flutter/ui/welcome/login/login_page.dart';
import 'package:simple_todo_flutter/ui/welcome/splash/splash_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  static Future<dynamic> showBottomEditPage(BuildContext context, {Task? task}) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;

    return await showModalBottomSheet(
        context: rootContext,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        isScrollControlled: true,
        builder: (context) {
          return TaskEditPage(task: task ?? null);
        });
  }

  static dynamic back(BuildContext context, {dynamic result}) async {
    return Navigator.of(context).pop(result);
  }

  static Future<DateTime> showTimePicker(BuildContext context,
      {DateTime? value,
      bool isFromRoot = true}) async {
    late TimeOfDay result;
    final rootContext = isFromRoot ?
        Provider.of<RootData>(context, listen: false).rootContext : context;

    await Navigator.of(rootContext).push(
      showPicker(
        context: context,
        value: value != null ? TimeOfDay.fromDateTime(value) : TimeOfDay.now(),
        borderRadius: 20.r,
        blurredBackground: true,
        okText: "action.ok".tr(),
        cancelText: "action.cancel".tr(),
        onChange: (time) => result = time,
      ),);

    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, result.hour, result.minute);
  }
}