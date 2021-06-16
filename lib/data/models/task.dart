import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:uuid/uuid.dart';

class Task {
  String id = "${Uuid().v1()}";
  String title ;
  String description = Constants.EMPTY_STRING;
  List<CheckItem> checkList = [];
  int? time;
  int? date;

  Task({this.title = Constants.EMPTY_STRING});
}

class CheckItem {
  String text;
  bool isCompleted;

  CheckItem({this.text = Constants.EMPTY_STRING, this.isCompleted = false});
}