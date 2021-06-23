import 'dart:async';

import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/task_regulalry_repository.dart';

class RegularlyPageViewModel {
  TaskRegularRepository _repo = TaskRegularRepository();

  final streamTasks = StreamController<List<TaskRegular>>();
  List<TaskRegular> tasks = [];

  initRepo() async {
    await _repo.initTaskBox();

    tasks = _repo.getAllTasks();
    streamTasks.sink.add(tasks);
  }
}