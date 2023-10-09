import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_go_brr/data/models/dev_settings.dart';
import 'package:tasks_go_brr/data/models/root_data.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/data/models/task_regular/task_regular.dart';
import 'package:tasks_go_brr/data/models/user_info/user_info.dart';
import 'package:tasks_go_brr/main_page.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/ui/custom/color_dialog.dart';
import 'package:tasks_go_brr/ui/dev/dev_info_page.dart';
import 'package:tasks_go_brr/ui/purchase/purchase_page.dart';
import 'package:tasks_go_brr/ui/tags/tags_dialog.dart';
import 'package:tasks_go_brr/ui/task/task_edit_page.dart';
import 'package:tasks_go_brr/ui/task/task_regularly/task_reg_edit_page.dart';
import 'package:tasks_go_brr/ui/user/user_edit_page.dart';
import 'package:tasks_go_brr/ui/welcome/login/login_page.dart';
import 'package:tasks_go_brr/ui/welcome/splash/splash_page.dart';
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

  static Future<dynamic> showTagDialog(
      BuildContext context, List<String> selectedTags) async {
    return await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black54,
        pageBuilder: (BuildContext context, _, __) {
          return TagsDialog(selectedTags: selectedTags);
        },
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: Opacity(
                opacity: 1 - animation.drive(tween).value.dy, child: child),
          );
        },
      ),
    );
  }

  static Future<dynamic> showBottomTaskEditPage(BuildContext context,
      {Task? task, required DateTime date}) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;

    context.setNavBarColorLight();
    var result = await showModalBottomSheet(
        context: rootContext,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        isScrollControlled: true,
        builder: (context) {
          return TaskEditPage(
            task: task ?? null,
            date: date,
          );
        });
    context.setNavBarColorDark();

    return result;
  }

  static Future<dynamic> showBottomTaskRegEditPage(BuildContext context,
      {TaskRegular? task, required DateTime dateTime}) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;

    context.setNavBarColorLight();
    var result = await showModalBottomSheet(
        context: rootContext,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        isScrollControlled: true,
        builder: (context) {
          return TaskRegEditPage(
            task: task ?? null,
            dateTime: dateTime,
          );
        });
    context.setNavBarColorDark();

    return result;
  }

  static Future<dynamic> showBottomPurchasePage(BuildContext context) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;

    context.setNavBarColorLight();
    var result = await showModalBottomSheet(
        context: rootContext,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        builder: (context) {
          return PurchasePage();
        });
    context.setNavBarColorDark();

    return result;
  }

  static dynamic back(BuildContext context, {dynamic result}) async {
    return Navigator.of(context).pop(result);
  }

  static Future<DateTime?> showTimePicker(BuildContext context,
      {DateTime? value,
      bool isFromRoot = true,
      bool? isFirstHalfOfDay,
      bool isDeleteWhenHas = false}) async {
    TimeOfDay? result;
    final rootContext = isFromRoot
        ? Provider.of<RootData>(context, listen: false).rootContext
        : context;

    await Navigator.of(rootContext).push(
      showPicker(
        context: context,
        value: value != null
            ? Time.fromTimeOfDay(TimeOfDay.fromDateTime(value), null)
            : Time.fromTimeOfDay(TimeOfDay.now(), null),
        borderRadius: 20.r,
        elevation: 0,
        maxHour:
            isFirstHalfOfDay == null || isFirstHalfOfDay == false ? 23 : 12,
        minHour: isFirstHalfOfDay == null || isFirstHalfOfDay == true ? 1 : 12,
        is24HrFormat: true,
        okText: "action.ok".tr(),
        cancelText: isDeleteWhenHas && value != null
            ? "action.delete".tr()
            : "action.cancel".tr(),
        onChange: (time) => result = time,
        accentColor: context.primaryAccent,
        unselectedColor: context.onSurfaceAccent,
        barrierColor: Colors.black54,
        themeData: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: context.primaryAccent,
            onPrimary: context.onPrimary,
            surface: context.surface,
            onSurface: context.onSurface,
          ),
          textTheme:
              TextTheme(headline2: TextStyle(color: context.onSurfaceAccent)),
          cardColor: context.surface,
        ),
      ),
    );

    if (result == null) return null;

    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, result!.hour, result!.minute);
  }

  static Future<DateTime?> showBeforeTimePicker(BuildContext context,
      {DateTime? value,
      bool isFromRoot = true,
      bool isDeleteWhenHas = false}) async {
    TimeOfDay? result;
    final rootContext = isFromRoot
        ? Provider.of<RootData>(context, listen: false).rootContext
        : context;

    await Navigator.of(rootContext).push(
      showPicker(
        context: context,
        value: Time.fromTimeOfDay(
            TimeOfDay.fromDateTime(value ?? Constants.TASK_BEFORE_TIME_DEFAULT),
            null),
        borderRadius: 20.r,
        elevation: 0,
        okText: "action.ok".tr(),
        cancelText: isDeleteWhenHas && value != null
            ? "action.delete".tr()
            : "action.cancel".tr(),
        iosStylePicker: true,
        is24HrFormat: true,
        minuteInterval: TimePickerInterval.FIVE,
        displayHeader: false,
        minMinute: 5,
        maxHour: 6,
        focusMinutePicker: true,
        minuteLabel: "dialog.minutes".tr(),
        hourLabel: "dialog.hours".tr(),
        onChange: (time) => result = time,
        accentColor: context.primaryAccent,
        unselectedColor: context.onSurfaceAccent,
        barrierColor: Colors.black54,
        themeData: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: context.primaryAccent,
            onPrimary: context.onPrimary,
            surface: context.surface,
            onSurface: context.onSurface,
          ),
          textTheme:
              TextTheme(headline2: TextStyle(color: context.onSurfaceAccent)),
          cardColor: context.surface,
        ),
      ),
    );

    if (result == null) return null;

    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, result!.hour, result!.minute);
  }

  static Future<DateTime?> showDateCalendarPicker(
      BuildContext context, DateTime initialDate) async {
    var now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now
          .subtract(Duration(days: 7 * CalendarCards.EXTEND_BEFORE_ON_WEEKS)),
      lastDate: DateTime(
        now.year + CalendarCards.EXTEND_AFTER_ON_YEARS,
      ),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: context.primaryAccent,
              onPrimary: context.onPrimary,
              surface: context.surface,
              onSurface: context.onSurface,
            ),
            dialogBackgroundColor: context.background,
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  static Future<dynamic> showDevInfoPage(BuildContext context) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;

    context.setNavBarColorLight();
    var result = await showModalBottomSheet(
        context: rootContext,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        builder: (context) {
          return DevInfoPage();
        });
    context.setNavBarColorDark();

    return result;
  }

  static Future<dynamic> showBottomUserEditPage(BuildContext context,
      {required UserInfo userInfo, required DevSettings devSettings}) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;

    context.setNavBarColorLight();
    var result = await showModalBottomSheet(
        context: rootContext,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        elevation: 0.0,
        builder: (context) {
          return UserEditPage(
            userInfo: userInfo,
            devSettings: devSettings,
          );
        });
    context.setNavBarColorDark();

    return result;
  }

  static Future<dynamic> showColorPickerDialog(BuildContext context,
      {required Color initialColor}) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;

    return await showDialog(
      context: rootContext,
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: ColorPickerDialog(
              initialColor: initialColor,
            ));
      },
    );
  }
}
