import 'package:uuid/uuid.dart';

class Task {
  String id = "${Uuid().v1()}";
  late String title;
  late String description;
  late List<String> checkList;
  late int? startTime = 0;
  late int? endTime;
  late int? date;

  Task({required this.title});
}