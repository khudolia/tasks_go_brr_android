import 'package:hive/hive.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/resources/constants.dart';

part 'day.g.dart';

@HiveType(typeId: Models.DAY_ID)
class Day {

  @HiveField(0)
  late int millisecondsSinceEpoch;

  @HiveField(1)
  List<Task> tasks = [];

  @HiveField(2)
  int numberOfCompletedTasks = 0;

  List<Task> getAllCompletedTasks() {
    return tasks.where((element) => element.status).toList();
  }
}