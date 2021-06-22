import 'package:hive/hive.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

part 'day.g.dart';

@HiveType(typeId: Models.DAY_ID)
class Day {

  @HiveField(0)
  late int millisecondsSinceEpoch;

  @HiveField(1)
  List<Task> tasks = [];

  @HiveField(2)
  int numberOfCompletedTasks = 0;
}