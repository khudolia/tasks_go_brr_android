import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class TaskRegularRepository extends LocalRepository {

  initTaskBox() async {
    await initBox<TaskRegular>(Repo.TASK_REGULAR);
  }

  Future<void> addTask(TaskRegular task) async {
    await addItem(task.id, task);
  }

  Future<void> updateTask(TaskRegular task) async {
    await updateItem(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await deleteItem(id);
  }

  List<TaskRegular> getAllTasks() {
    return getAllItems() as List<TaskRegular>;
  }

}