import 'package:easy_localization/easy_localization.dart';
import 'package:simple_todo_flutter/data/repositories/task_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class PlanPageViewModel {
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

  TaskRepository repo = TaskRepository();

  initRepo() async {
    await repo.initTaskBox();
  }

  String getDayTitle(int dayOfWeek) {
    return daysLocalized[dayOfWeek - 1];
  }

  String getMonthTitle(int month) {
    return monthsLocalized[month - 1];
  }

  DateTime getCurrentDayOfWeek() {
    return DateTime.now();
  }

  DateTime getStartOfDaysList(DateTime currentDay) {
    return currentDay
        .subtract(Duration(days: CalendarCards.EXTEND_BEFORE_ON_WEEKS * 7));
  }

  DateTime getEndOfDaysList(DateTime currentDay) {
    return DateTime(currentDay.year,
        currentDay.month + 1 + CalendarCards.EXTEND_AFTER_ON_MONTHS, 0);
  }

  int getLengthOfRenderDays(DateTime currentDay) {
    return getStartOfDaysList(currentDay)
            .difference(getEndOfDaysList(currentDay))
            .inDays
            .abs() +
        2;
  }

  int getPositionOfCenterDate(DateTime currentDay) {
    return currentDay.day - getStartOfDaysList(currentDay).day;
  }

  DateTime getDateFromPosition(DateTime currentDay, int position) {
    return getStartOfDaysList(currentDay).add(Duration(days: position));
  }
}