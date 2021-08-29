import 'package:hive/hive.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:uuid/uuid.dart';

part 'task_regular.g.dart';

@HiveType(typeId: Models.TASK_REGULAR_ID)
class TaskRegular {

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

  ///in milliseconds or null
  @HiveField(5)
  int? remindBeforeTask = Constants.TASK_BEFORE_TIME_DEFAULT.millisecondsSinceEpoch;

  ///in milliseconds
  @HiveField(6)
  int? initialDate;

  @HiveField(7)
  int? repeatType = Repeat.DAILY;

  @HiveField(8)
  List<bool> repeatLayout = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  ///days in milliseconds : completed/missed/deleted(true/false/null)
  @HiveField(9)
  Map<int, bool?> statistic = {};

  @HiveField(10)
  bool status = Status.INCOMPLETE;

  ///tag's id
  @HiveField(11)
  List<String> tags = [];
}