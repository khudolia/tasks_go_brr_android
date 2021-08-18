import 'dart:async';

import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/day_repository.dart';
import 'package:simple_todo_flutter/data/repositories/tags_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class DayCardViewModel {
  DayRepository _repo = DayRepository();
  TagsRepository _repoTags = TagsRepository();

  List<Task> tasks = [];

  final streamTasks = StreamController<List<Task>>();

  initRepo(DateTime date) async {
    await _repoTags.initTagsBox();
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

  removeTask(Task task) async {
    await _repo.deleteTask(task);
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

  checkTaskForCompatibility(Task task, DateTime currentDate) async {
    if (task.date!.onlyDateInMilli() ==
        currentDate.millisecondsSinceEpoch.onlyDateInMilli()) {
      tasks[tasks.indexWhere((element) => element.id == task.id)] = task;
    }
  }

  Tag getTag(String id) =>
      _repoTags.getAllTags().firstWhere((element) => element.id == id);
}