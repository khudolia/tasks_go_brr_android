import 'dart:async';

import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/day_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class DayCardViewModel {
  DayRepository _repo = DayRepository();

  List<Task> tasks = [];

  final streamTasks = StreamController<List<Task>>();

  initRepo(DateTime date) async {
    await _repo.initTaskBox(date);

    tasks = _repo.getAllTasks();
    streamTasks.sink.add(tasks);
  }

  updateList(List<Task> items) {
    _repo.updateTaskList(items);
  }

  updateTask(Task task) async {
    await _repo.updateTask(task);
  }

  removeTask(int index) async {
    await _repo.deleteTask(tasks[index]);
  }

  changeTaskStatus(Task task) async {
    task.status = !task.status;

    await updateTask(task);
  }

  String getTaskTitle(int index) {
    return index < tasks.length
        ? tasks[index].title
        : Constants.EMPTY_STRING;
  }

  checkTaskForCompatibility(Task task, DateTime currentDate, int index){
    if (task.date!.onlyDateInMilli() ==
        currentDate.millisecondsSinceEpoch.onlyDateInMilli())
      tasks[index] = task;
    else
      removeTask(index);
  }
}