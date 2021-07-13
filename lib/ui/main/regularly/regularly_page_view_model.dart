import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/statistics_repository.dart';
import 'package:simple_todo_flutter/data/repositories/task_regulalry_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class RegularlyPageViewModel {
  TaskRegularRepository _repo = TaskRegularRepository();
  StatisticsRepository _repoStats = StatisticsRepository();

  final streamTasks = StreamController<List<TaskRegular>>();
  List<TaskRegular> tasks = [];
  bool showAllTasks = false;

  initRepo(DateTime dateTime) async {
    await _repo.initTaskBox();
    await _repoStats.initStatsBox(dateTime);

    tasks = _repo.getAllTasks();
    streamTasks.sink.add(tasks);
  }

  Future<void> updateTask(TaskRegular task) async {
    await _repo.updateTask(task);
  }

  Future<void> deleteTask(TaskRegular task) async {
    await _repo.deleteTask(task.id);
  }

  Future<void> deleteTaskForDay(TaskRegular task, DateTime dateTime) async {
    task.statistic[dateTime.millisecondsSinceEpoch.onlyDateInMilli()] = null;
    await updateTask(task);
  }

  Future<void> addCompletedDay(TaskRegular task, DateTime dateTime) async {
    task.statistic[dateTime.millisecondsSinceEpoch.onlyDateInMilli()] = true;
    await updateTask(task);
    await _repoStats.changeCompletedTasks(dateTime, true, false);
  }

  bool isTaskShouldBeShown(TaskRegular task, DateTime currentDate) {
    if(showAllTasks)
      return showAllTasks;

    if(task.statistic.containsKey(currentDate.millisecondsSinceEpoch))
      if (task.statistic[currentDate.millisecondsSinceEpoch] == true ||
          task.statistic[currentDate.millisecondsSinceEpoch] == null)
        return false;

    switch (task.repeatType) {
      case Repeat.DAILY:
        return true;

      case Repeat.WEEKLY:
        return task.initialDate!.toDate().weekday == currentDate.weekday;

      case Repeat.MONTHLY:
        return task.initialDate!.toDate().day == currentDate.day;

      case Repeat.ANNUALLY:
        return task.initialDate!.toDate().day == currentDate.day &&
            task.initialDate!.toDate().month == currentDate.month;

      case Repeat.CUSTOM:
        return task.repeatLayout[currentDate.weekday];

      default:
        return false;
    }
  }

  Future<DateTime?> showDateCalendarPicker(
      BuildContext context, DateTime dateTime) async {
    var now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year + CalendarCards.EXTEND_AFTER_ON_YEARS,),
    );
    return picked;
  }
}