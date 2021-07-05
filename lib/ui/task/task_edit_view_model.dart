import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/day_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class TaskEditViewModel {
  DayRepository _repo = DayRepository();
  Task task = Task();

  initRepo(DateTime date) async {
    await _repo.initTaskBox(date);
  }

  changeTitle(String text) {
    task.title = text;
  }

  completeTask(Task? inputTask, DateTime time) {
    if(inputTask == null) {
      saveTask(time);
    } else {
      updateTask();
    }

  }

  saveTask(DateTime time) async {
    if(task.date == null)
      task.date = time.millisecondsSinceEpoch
          .toDate()
          .onlyDate()
          .millisecondsSinceEpoch;

    await _repo.addTask(task);
  }

  updateTask() async {
    await _repo.updateTask(task);
  }

  resetTask() {
    task = Task();
  }

  updateChecklist(List<CheckItem> list){
    task.checkList
      ..clear()
      ..addAll(list);
  }

  addNewItemToChecklist(String text) {
    task.checkList = []
      ..add(CheckItem()..text = text)
      ..addAll(task.checkList);
  }

  changeCheckItemStatus(int index) async {
    task.checkList[index].isCompleted = !task.checkList[index].isCompleted;
  }

  changeCheckItemText(CheckItem item, String text) async {
    item.text = text;

    await updateTask();
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
        ? time.toDate()
        : null;
  }

  Future<void> showTimePicker(BuildContext context) async {
    var result = await Routes.showTimePicker(
      context,
      value: getDateTimeFromMilliseconds(task.time),
      isFromRoot: true,
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