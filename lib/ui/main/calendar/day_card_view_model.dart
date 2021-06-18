import 'dart:async';

import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/task_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class DayCardViewModel {
  TaskRepository _repo = TaskRepository();

  List<Task> tasks = [];

  final streamTasks = StreamController<List<Task>>();

  initRepo(DateTime date) async {
    await _repo.initTaskBox();

     tasks = _repo.getAllTasks().where((element) =>
        date.isSameDate(DateTime.fromMillisecondsSinceEpoch(element.date!))).toList();
    streamTasks.sink.add(tasks);
  }

  List<Task> getTasksForToday() {
    return tasks;
  }

  updateList(List<Task> items) {
    tasks
      ..clear()
      ..addAll(items);
  }

  removeTask(int index) {
    tasks.removeAt(index);
  }

  changeTaskStatus(Task task) async {
    task.status = !task.status;

    await _repo.updateTask(task);
  }

  Future<void> deleteTaskDB(String index) async {
    await _repo.deleteTask(index);
  }

  String getTaskTitle(int index) {
    return index < tasks.length
        ? tasks[index].title
        : Constants.EMPTY_STRING;
  }
}