import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/background/notifications/notifications_service.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/task_regulalry_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/notifications.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class TaskRegViewModel {
  TaskRegularRepository _repo = TaskRegularRepository();

  TaskRegular task = TaskRegular();

  initRepo() async {
    await _repo.initTaskBox();
  }

  completeTask(BuildContext context, TaskRegular? inputTask) async {
    await scheduleNotifications(context);

    if(inputTask == null) {
      await saveTask();
    } else {
      await updateTask();
    }

  }

  saveTask() async {
    await _repo.addTask(task);
  }

  updateTask() async {
    await _repo.updateTask(task);
  }

  resetTask() {
    task = TaskRegular();
  }

  addNewItemToChecklist(String text) {
    task.checkList = []
      ..add(CheckItem()..text = text)
      ..addAll(task.checkList);
  }

  updateChecklist(List<CheckItem> list){
    task.checkList
      ..clear()
      ..addAll(list);
  }

  changeCheckItemStatus(int index) async {
    task.checkList[index].isCompleted = !task.checkList[index].isCompleted;
  }

  changeCheckItemText(CheckItem item, String text) async {
    item.text = text;

    await updateTask();
  }

  changeRepeatType(int repeatType) {
    task.repeatType = repeatType;

    if (repeatType == Repeat.CUSTOM)
      updateDefaultRepeatLayout();
  }

  updateDefaultRepeatLayout() {
    if (task.repeatLayout
            .firstWhere((element) => element, orElse: () => false) ==
        false) {
      task.repeatLayout[task.initialDate!.onlyDate().weekday - 1] = true;
    }
  }

  String getFormattedTime(int? time) {
    return time != null
        ? Time.getTimeFromMilliseconds(time)
        : Constants.EMPTY_STRING;
  }

  DateTime? getDateTimeFromMilliseconds(int? time) {
    return time != null
        ? time.toDate()
        : null;
  }

  String getFormattedDate(int? time) {
    return time != null
        ? Time.getDateFromMilliseconds(time)
        : Constants.EMPTY_STRING;
  }

  Future<void> showTimePicker(BuildContext context) async {
    var result = await Routes.showTimePicker(
      context,
      value: getDateTimeFromMilliseconds(task.time),
      isFromRoot: false,
    );

    if(result != null)
      task.time = result.millisecondsSinceEpoch;
  }

  Future<void> showDateCalendarPicker(BuildContext context) async {
    var now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: getDateTimeFromMilliseconds(task.initialDate) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year + CalendarCards.EXTEND_AFTER_ON_YEARS,),
    );
    if (picked != null) {
      task.initialDate = picked.millisecondsSinceEpoch;
      updateDefaultRepeatLayout();
    }
  }

  Future scheduleNotifications(BuildContext context) async {
    if(task.initialDate!.toDate().putDateAndTimeTogether(
        task.time!.toDate()).isAfter(DateTime.now())) {
      await NotificationService.initNotificationSystem(context);
      await NotificationService.pushRegularTask(task);

      if(task.remindBeforeTask != null)
        await NotificationService.pushBeforeRegularTask(task);
      else
        await NotificationService.deleteNotification(
            NotificationUtils.getBeforeTaskId(task));
    }
  }
}