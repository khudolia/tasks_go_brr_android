import 'package:simple_todo_flutter/data/models/task.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class TaskEditViewModel {
  Task task = Task(title: Constants.EMPTY_STRING);

  changeTitle(String text) {
    task.title = text;
  }

  saveTask() {

  }

  updateTask() {

  }
}