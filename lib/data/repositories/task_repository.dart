import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class TaskRepository extends LocalRepository {

  initTaskBox() async {
    await initBox<Task>(TaskRepo.BOX);
  }

  addTask(Task task) async {
    await addItem(task.id, task);
  }

  updateTask(Task task) async {
    await updateItem(task.id, task);
  }

  List<Task> getAllTasks() {
    return getAllItems() as List<Task>;
  }

  Iterable<Task> getAllTasksIterable() {
    return box.values as Iterable<Task>;
  }

  Future<void> deleteTask(String id) async {
    await deleteItem(id);
  }
}