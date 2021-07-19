import 'package:simple_todo_flutter/data/models/day/day.dart';
import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/day_repository.dart';
import 'package:simple_todo_flutter/data/repositories/statistics_repository.dart';
import 'package:simple_todo_flutter/data/repositories/task_regulalry_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';
import 'package:collection/collection.dart';

class StatsPageViewModel {
  StatisticsRepository _repo = StatisticsRepository();
  DayRepository _repoDay = DayRepository();
  TaskRegularRepository _repoRegular = TaskRegularRepository();

  Statistics stats = Statistics();
  List<Day?> days = [];

  Future<int> initRepo(DateTime dateTime) async {
    stats = await _repo.initStatsBox(dateTime);
    await _repoDay.initTaskBox(dateTime);
    await _repoRegular.initTaskBox();

    days = _repoDay.getAllDays();

    return 0;
  }

  updateStats() async {
    await _repo.updateStats(stats);
  }

  int getCompletedDefaultTasks(DateTime dateTime) {
    var day = days.firstWhereOrNull((element) =>
        element!.millisecondsSinceEpoch.onlyDateInMilli() ==
        dateTime.onlyDate().millisecondsSinceEpoch);

    if(day == null)
      return 0;

    return day.getAllCompletedTasks().length;
  }

  int getCompletedRegularTasks(DateTime dateTime) {
    List<TaskRegular> tasks = _repoRegular.getAllTasks().where((element) =>
        element.statistic[dateTime.millisecondsSinceEpoch.onlyDateInMilli()] ==
        true).toList();
    return tasks.length;
  }

  int getAllCompletedTasks(DateTime dateTime) {
    return getCompletedDefaultTasks(dateTime) + getCompletedRegularTasks(dateTime);
  }

  int getMaxCompletedTasksInWeek() {
    int max = stats.goalOfTasksInDay;

    for (int i = 0; i < 7; i++) {
       int tasksAtAll = getAllCompletedTasks(
            DateTime.now().subtract(Duration(days: 6 - i)));
        if (tasksAtAll > max)
          max = tasksAtAll;

    }
    return max + Constants.CHART_MAX_VALUE_EXTEND;
  }

  int getDaysInRow() {
    int value = 0;
    int lastDate = 0;
    int today = DateTime.now().onlyDate().millisecondsSinceEpoch;

    for (Day? day in days) {
      if (day!.millisecondsSinceEpoch <= today) {
        if (day.millisecondsSinceEpoch
                .onlyDate()
                .difference(lastDate.toDate())
                .inDays >
            1) {
          value = 0;
        }

        if (getAllCompletedTasks(day.millisecondsSinceEpoch.onlyDate()) > 0) {
          value++;
        } else {
          if(day.millisecondsSinceEpoch.onlyDateInMilli() != today)
            value = 0;
        }

        lastDate = day.millisecondsSinceEpoch.onlyDateInMilli();
      }
    }

    updateMaxDaysInRow(value);

    return value;
  }

  updateMaxDaysInRow(int value) async {
    if(value > stats.maxDaysInRow)
      await _repo.updateStats(stats..maxDaysInRow = value);
  }
}