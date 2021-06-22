import 'package:easy_localization/easy_localization.dart';

class Time {

  static String getTimeFromMilliseconds(int milliseconds) {
    return DateFormat('kk:mm').format(
        DateTime.fromMillisecondsSinceEpoch(
            milliseconds));
  }

  static String getDateFromMilliseconds(int milliseconds) {
    return DateFormat('dd.MM.yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            milliseconds));
  }

  static String getStringFromMilliseconds(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(
            milliseconds).toString();
  }

}

extension DateOnly on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }

  DateTime onlyDate() {
    return DateTime(this.year, this.month, this.day);
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
  String timeToString() {
    return DateTime.fromMillisecondsSinceEpoch(
        this).toString();
  }

  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(
        this);
  }
}