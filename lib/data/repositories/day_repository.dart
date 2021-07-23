import 'package:simple_todo_flutter/data/models/day/day.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class DayRepository extends LocalRepository {
  late Day day;

  initTaskBox(DateTime date) async {
    await initBox<Day>(Repo.DAY);
    day = await _initDay(date.onlyDate());
  }

  Future<Day> _initDay(DateTime date) async {
    Day? dayFromDB = await getItem(_getProperDayId(date));

    if(dayFromDB != null) {
      return dayFromDB;
    } else {
      var newDay = Day()
        ..millisecondsSinceEpoch =
            date.millisecondsSinceEpoch.onlyDateInMilli();
      await addItem(_getProperDayId(date), newDay);
      return newDay;
    }
  }

  addTask(Task task) async {
    Day day = task.date!.onlyDateInMilli() ==
            this.day.millisecondsSinceEpoch.onlyDateInMilli()
        ? this.day
        : await _initDay(task.date!.toDate());

    day.tasks.add(task);
    await updateItem(_getProperDayId(task.date!.toDate()), day);
  }

  updateTask(Task task) async {
    Day day = task.date!.onlyDateInMilli() ==
            this.day.millisecondsSinceEpoch.onlyDateInMilli()
        ? this.day
        : await _initDay(task.date!.toDate());

    if(day.tasks.contains(task)) {
      day.tasks[day.tasks.indexWhere((element) => element.id == task.id)] =
          task;
    } else {
      day.tasks.add(task);
      this.day.tasks.removeWhere((element) => element.id == task.id);

      await updateItem(
          _getProperDayId(this.day.millisecondsSinceEpoch.toDate().onlyDate()), this.day);
    }

    await updateItem(_getProperDayId(task.date!.toDate().onlyDate()), day);
  }

  updateTaskList(List<Task> list) async {
    day.tasks
      ..clear()
      ..addAll(list);

    await updateItem(_getProperDayId(day.millisecondsSinceEpoch.toDate()), day);
  }

  getTask(String id) async {
    return day.tasks.firstWhere((element) => element.id == id);
  }

  List<Task> getAllTasks() {
    return day.tasks;
  }

  Future<void> deleteTask(Task task) async {
    Day day = task.date!.onlyDateInMilli() ==
            this.day.millisecondsSinceEpoch.onlyDateInMilli()
        ? this.day
        : await _initDay(task.date!.toDate());

    day.tasks.removeWhere((element) => element.id == task.id);
    await updateItem(_getProperDayId(task.date!.toDate()), day);
  }

  List<Day> getAllDays() {
    return getAllItems() as List<Day>;
  }

  String _getProperDayId(DateTime date) {
    return date.onlyDate().millisecondsSinceEpoch.timeToString();
  }
}