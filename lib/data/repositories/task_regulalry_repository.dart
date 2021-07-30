import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

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

  bool isTaskShouldBeShown(TaskRegular task, DateTime currentDate) {
    currentDate = currentDate.onlyDate();
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
        return task.repeatLayout[currentDate.weekday - 1];

      default:
        return false;
    }
  }

  List<TaskRegular> getListOfTasksThatShouldBeShown(DateTime currentDate) {
    return getAllTasks()
        .where((element) => isTaskShouldBeShown(element, currentDate))
        .toList();
  }
}