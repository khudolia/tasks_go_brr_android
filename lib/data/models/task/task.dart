import 'package:hive/hive.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: Models.TASK_ID)
class Task {
  @HiveField(0)
  String id = "${Uuid().v1()}";

  @HiveField(1)
  late String title = Constants.EMPTY_STRING;

  @HiveField(2)
  String description = Constants.EMPTY_STRING;

  @HiveField(3)
  List<CheckItem> checkList = [];

  @HiveField(4)
  int? time;

  @HiveField(5)
  int? date;

  @HiveField(6)
  bool status = Status.INCOMPLETE;
}

@HiveType(typeId: Models.CHECK_ITEM_ID)
class CheckItem {
  @HiveField(0)
  late String text = Constants.EMPTY_STRING;

  @HiveField(1)
  bool isCompleted = false;
}