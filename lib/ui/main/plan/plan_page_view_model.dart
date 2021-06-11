import 'package:easy_localization/easy_localization.dart';
import 'package:simple_todo_flutter/data/models/task.dart';

class PlanPageViewModel {
  List<Task> taskList = [
    Task(title: "Task 1"),
    Task(title: "Task 2"),
    Task(title: "Task 3"),
    Task(title: "Task 4"),
  ];

  List<String> daysLocalized = [
    "weekday.monday".tr(),
    "weekday.tuesday".tr(),
    "weekday.wednesday".tr(),
    "weekday.thursday".tr(),
    "weekday.friday".tr(),
    "weekday.saturday".tr(),
    "weekday.sunday".tr()
  ];

  List<String> monthsLocalized = [
    "month.january".tr(),
    "month.february".tr(),
    "month.march".tr(),
    "month.april".tr(),
    "month.may".tr(),
    "month.june".tr(),
    "month.july".tr(),
    "month.august".tr(),
    "month.september".tr(),
    "month.october".tr(),
    "month.november".tr(),
    "month.december".tr()
  ];

  String getDayTitle(int dayOfWeek) {
    return daysLocalized[dayOfWeek];
  }

  String getMonthTitle(int month) {
    return monthsLocalized[month - 1];
  }

  int getCurrentDayOfWeek() {
    return DateTime.now().weekday;
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  List<Task> getTasks() {
    return taskList;
  }

}