import 'package:tasks_go_brr/data/models/day/day.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/data/repositories/base/local_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/utils/time.dart';

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

  bool isTaskExist(String id) {
    for (Day day in getAllDays())
      for (Task task in day.tasks)
        if (task.id == id) return true;
    return false;
  }

  String _getProperDayId(DateTime date) {
    return date.onlyDate().millisecondsSinceEpoch.timeToString();
  }
}