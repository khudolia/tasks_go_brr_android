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
}