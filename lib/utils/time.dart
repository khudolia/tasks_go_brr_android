import 'package:easy_localization/easy_localization.dart';

class Time {
  static String getTimeFromMilliseconds(int milliseconds) => DateFormat('kk:mm')
      .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));

  static String getBeforeTimeFromMilliseconds(int milliseconds) =>
      DateFormat('HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));

  static String getDateFromMilliseconds(int milliseconds) =>
      DateFormat('dd.MM.yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));

  static String getStringFromMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds).toString();

  static DateTime getBeforeTimeReminder(
          DateTime initialTime, DateTime beforeTime) =>
      initialTime.subtract(
          Duration(hours: beforeTime.hour, minutes: beforeTime.minute));
}

class DatesLocalized {
  static List<String> days = [
    "weekday.monday".tr(),
    "weekday.tuesday".tr(),
    "weekday.wednesday".tr(),
    "weekday.thursday".tr(),
    "weekday.friday".tr(),
    "weekday.saturday".tr(),
    "weekday.sunday".tr()
  ];

  static List<String> daysShort = [
    "weekday.monday".tr().substring(0, 2),
    "weekday.tuesday".tr().substring(0, 2),
    "weekday.wednesday".tr().substring(0, 2),
    "weekday.thursday".tr().substring(0, 2),
    "weekday.friday".tr().substring(0, 2),
    "weekday.saturday".tr().substring(0, 2),
    "weekday.sunday".tr().substring(0, 2)
  ];

  static List<String> months = [
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
}

extension DateOnly on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }

  DateTime onlyDate() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime putDateAndTimeTogether(DateTime time) {
    return DateTime(this.year, this.month, this.day, time.hour, time.minute);
  }
}

extension DateOnlyInt on int {
  DateTime onlyDate() {
    var date = this.toDate();
    return DateTime(date.year, date.month, date.day);
  }

  int onlyDateInMilli() {
    var date = this.toDate();
    return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
  }
}

extension Date on int {

  String getDayTitle() => DatesLocalized.days[this - 1];
  String getDayTitleShort() => DatesLocalized.daysShort[this - 1];
  String getMonthTitle() => DatesLocalized.months[this - 1];

  String timeToString() {
    return DateTime.fromMillisecondsSinceEpoch(
        this).toString();
  }

  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(
        this);
  }

  DateTime onlyTime() {
    var now = DateTime.now();
    var thisTime = this.toDate();
    return DateTime(now.year, now.month, now.day, thisTime.hour, thisTime.minute);
  }
}