import 'dart:async';

import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/day_repository.dart';
import 'package:simple_todo_flutter/data/repositories/statistics_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class DayCardViewModel {
  DayRepository _repo = DayRepository();
  StatisticsRepository _repoStats = StatisticsRepository();

  List<Task> tasks = [];
  Statistics stats = Statistics();

  final streamTasks = StreamController<List<Task>>();

  initRepo(DateTime date) async {
    await _repo.initTaskBox(date);
    stats = await _repoStats.initStatsBox(date);

    tasks = _repo.getAllTasks();
    streamTasks.sink.add(tasks);
  }

  updateList(List<Task> items) {
    _repo.updateTaskList(items);
  }

  updateTask(Task task) async {
    await _repo.updateTask(task);
  }

  removeTask(Task task) async {
    await _repo.deleteTask(task);
    await changeInStats(task.date!.onlyDateInMilli(), false);
  }

  changeTaskStatus(Task task) async {
    task.status = !task.status;

    await updateTask(task);

    await changeInStats(task.date!, task.status);
  }

  String getTaskTitle(int index) {
    return index < tasks.length
        ? tasks[index].title
        : Constants.EMPTY_STRING;
  }

  checkTaskForCompatibility(Task task, DateTime currentDate, int index) async {
    if (task.date!.onlyDateInMilli() ==
        currentDate.millisecondsSinceEpoch.onlyDateInMilli()) {
      tasks[index] = task;
    } else {
      await changeInStats(currentDate.millisecondsSinceEpoch.onlyDateInMilli(), false);
      await changeInStats(task.date!.onlyDateInMilli(), true);
    }
  }

  changeInStats(int dateTime, bool shouldAdd) async {
    var dayStat = stats.days
        .firstWhere((element) => element!.date == dateTime)!;

    if (shouldAdd)
      dayStat.completedDefaultTasks++;
    else
      dayStat.completedDefaultTasks--;

    await _repoStats.updateStats(stats);
  }
}