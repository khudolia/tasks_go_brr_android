import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/utils/time.dart';

class PlanPageViewModel {

  String getDayTitle(int dayOfWeek) {
    return dayOfWeek.getDayTitleShort();
  }

  String getMonthTitle(int month) {
    return month.getMonthTitle();
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

  int getPositionOfCenterDate() {
    return CalendarCards.EXTEND_BEFORE_ON_WEEKS * 7;
  }

  DateTime getDateFromPosition(DateTime currentDay, int position) {
    return getStartOfDaysList(currentDay).add(Duration(days: position));
  }
}