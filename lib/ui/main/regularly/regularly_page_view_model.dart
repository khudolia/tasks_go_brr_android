import 'dart:async';

import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/task_regulalry_repository.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class RegularlyPageViewModel {
  TaskRegularRepository _repo = TaskRegularRepository();

  final streamTasks = StreamController<List<TaskRegular>>();
  List<TaskRegular> tasks = [];
  bool showAllTasks = false;

  initRepo(DateTime dateTime) async {
    await _repo.initTaskBox();

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
  }

  bool isTaskShouldBeShown(TaskRegular task, DateTime currentDate) {
    if (showAllTasks)
      return showAllTasks;

    return _repo.isTaskShouldBeShown(task, currentDate);
  }
  List<String> getListOfDatesForTask(TaskRegular task, DateTime currentDate) {
    List<String> list = [];

    for(int i = 0; i < task.repeatLayout.length; i++){
      if(task.repeatLayout[i])
        list.add(i.getDayTitleShort());
    }
    return list;
  }
}