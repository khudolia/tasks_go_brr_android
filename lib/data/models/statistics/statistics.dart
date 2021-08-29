import 'package:hive/hive.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:uuid/uuid.dart';

part 'statistics.g.dart';

@HiveType(typeId: Models.STATISTICS_ID)
class Statistics {

  @HiveField(0)
  String id = "${Uuid().v1()}";

  @HiveField(1)
  int goalOfTasksInDay = Constants.DEFAULT_GOAL_OF_TASKS_IN_DAY;

  @HiveField(2)
  int daysInRow = 0;

  @HiveField(3)
  int maxDaysInRow = 0;
}