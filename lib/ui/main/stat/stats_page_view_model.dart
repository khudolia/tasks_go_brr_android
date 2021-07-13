import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/repositories/statistics_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class StatsPageViewModel {
  StatisticsRepository _repo = StatisticsRepository();

  Statistics stats = Statistics();

  Future<int> initRepo(DateTime dateTime) async {
    stats = await _repo.initStatsBox(dateTime);
    return 0;
  }

  updateStats() async {
    await _repo.updateStats(stats);
  }

  int getCompletedDefaultTasks(DateTime dateTime) {
    return stats.days
        .firstWhere((element) =>
            element!.date == dateTime.onlyDate().millisecondsSinceEpoch)!
        .completedDefaultTasks;
  }

  int getAllCompletedTasks(DateTime dateTime) {
    var day = stats.days.firstWhere((element) =>
        element!.date == dateTime.onlyDate().millisecondsSinceEpoch)!;
    return day.completedDefaultTasks + day.completedRegularTasks;
  }

  DayStats? getDayForChart(int index) {
    var givenDay = DateTime.now().subtract(Duration(days: 6 -  index));

    return stats.days.firstWhere(
        (element) =>
            element!.date == givenDay.onlyDate().millisecondsSinceEpoch,
        orElse: () => null);
  }

  int getMaxCompletedTasksInWeek() {
    int max = stats.goalOfTasksInDay;

    for (int i = 0; i < 7; i++) {
      DayStats? day = getDayForChart(i);

      if(day != null) {
        int tasksAtAll = day.completedDefaultTasks + day.completedRegularTasks;
        if (tasksAtAll > max)
          max = tasksAtAll;
      }
    }
    return max + Constants.CHART_MAX_VALUE_EXTEND;
  }
}