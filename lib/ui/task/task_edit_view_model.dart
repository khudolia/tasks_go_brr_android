import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/background/notifications/notifications_service.dart';
import 'package:simple_todo_flutter/data/models/tag/tag.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/repositories/day_repository.dart';
import 'package:simple_todo_flutter/data/repositories/tags_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/notifications.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class TaskEditViewModel {
  DayRepository _repo = DayRepository();
  TagsRepository repoTags = TagsRepository();
  Task task = Task();

  initRepo(DateTime date) async {
    await repoTags.initTagsBox();
    await _repo.initTaskBox(date);
  }

  changeTitle(String text) {
    task.title = text;
  }

  completeTask(BuildContext context, Task? inputTask, DateTime time) async {
    await scheduleNotifications(context);

    if(inputTask == null) {
      await saveTask(time);
    } else {
      await updateTask();
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
        ? time.onlyDate().isSameDate(DateTime.now().onlyDate())
            ? "today".tr()
            : Time.getDateFromMilliseconds(time)
        : Constants.EMPTY_STRING;
  }

  DateTime? getDateTimeFromMilliseconds(int? time) {
    return time != null
        ? time.toDate()
        : null;
  }

  Future<void> showTimePicker(BuildContext context, {bool isDeleteWhenHas = false}) async {
    var result = await Routes.showTimePicker(
      context,
      value: getDateTimeFromMilliseconds(task.time),
      isFromRoot: true,
      isDeleteWhenHas: isDeleteWhenHas
    );

    if(result != null)
      task.time = result.millisecondsSinceEpoch;
    else
      if(isDeleteWhenHas)
        task.time = null;
  }

  Future<void> showDateCalendarPicker(BuildContext context) async {
    final DateTime? picked = await Routes.showDateCalendarPicker(
      context,
      getDateTimeFromMilliseconds(task.date) ?? DateTime.now(),
    );
    if (picked != null) task.date = picked.millisecondsSinceEpoch;
  }

  Future showBeforeTimePicker(BuildContext context, {bool isDeleteWhenHas = false}) async {
    var result = await Routes.showBeforeTimePicker(context,
        value: task.remindBeforeTask != null
            ? task.remindBeforeTask!.toDate()
            : null, isDeleteWhenHas: isDeleteWhenHas);

    if(result != null)
      task.remindBeforeTask = result.millisecondsSinceEpoch;
    else
      if(isDeleteWhenHas)
        task.remindBeforeTask = null;

    return result;
  }

  Future scheduleNotifications(BuildContext context) async {
    if(task.date!.toDate().putDateAndTimeTogether(
            task.time!.toDate()).isAfter(DateTime.now())) {
      await NotificationService.initNotificationSystem(context);
      await NotificationService.pushSingleTask(task);

      if(task.remindBeforeTask != null)
        await NotificationService.pushBeforeSingleTask(task);
      else
        await NotificationService.deleteNotification(
            NotificationUtils.getBeforeTaskId(task));
    }
  }

  Tag getTag(String id) {
    return repoTags.getAllTags().firstWhere((element) => element.id == id);
  }
}