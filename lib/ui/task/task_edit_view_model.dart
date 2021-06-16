import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/task.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class TaskEditViewModel {
  Task task = Task(title: Constants.EMPTY_STRING);

  changeTitle(String text) {
    task.title = text;
  }

  saveTask(BuildContext context) {
    Routes.back(context, result: task);
  }

  updateTask() {

  }

  updateChecklist(List<CheckItem> list){
    task.checkList
      ..clear()
      ..addAll(list);
  }

  addNewItemToChecklist(String text) {
    task.checkList = []
      ..add(CheckItem(text: text))
      ..addAll(task.checkList);
  }

  String getFormattedTime(int? time) {
    return time != null
        ? Time.getTimeFromMilliseconds(time)
        : Constants.EMPTY_STRING;
  }

  String getFormattedDate(int? time) {
    return time != null
        ? Time.getDateFromMilliseconds(time)
        : Constants.EMPTY_STRING;
  }

  DateTime? getDateTimeFromMilliseconds(int? time) {
    return time != null
        ? DateTime.fromMillisecondsSinceEpoch(time)
        : null;
  }

  Future<void> showTimePicker(BuildContext context) async {
    var result = await Routes.showTimePicker(
      context,
      value: getDateTimeFromMilliseconds(task.time),
      isFromRoot: false,
    );
    task.time = result.millisecondsSinceEpoch;
  }

  Future<void> showDateCalendarPicker(BuildContext context) async {
    var now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: getDateTimeFromMilliseconds(task.date) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year + CalendarCards.EXTEND_AFTER_ON_YEARS,),
    );
    if (picked != null) task.date = picked.millisecondsSinceEpoch;
  }
}