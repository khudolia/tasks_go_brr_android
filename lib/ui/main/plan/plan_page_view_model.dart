import 'package:easy_localization/easy_localization.dart';

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

  String getDayTitle(int dayOfWeek) {
    return daysLocalized[dayOfWeek];
  }

  int getCurrentDayOfWeek() {
    return DateTime.now().weekday;
  }
}