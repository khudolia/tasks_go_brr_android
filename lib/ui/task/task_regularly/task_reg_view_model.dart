import 'package:flutter/material.dart';
import 'package:tasks_go_brr/background/notifications/notifications_service.dart';
import 'package:tasks_go_brr/data/models/tag/tag.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/data/models/task_regular/task_regular.dart';
import 'package:tasks_go_brr/data/repositories/tags_repository.dart';
import 'package:tasks_go_brr/data/repositories/task_regulalry_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/resources/notifications.dart';
import 'package:tasks_go_brr/resources/routes.dart';
import 'package:tasks_go_brr/utils/time.dart';

class TaskRegViewModel {
  TaskRegularRepository _repo = TaskRegularRepository();
  TagsRepository _repoTags = TagsRepository();

  TaskRegular task = TaskRegular();

  initRepo() async {
    await _repoTags.initTagsBox();
    await _repo.initTaskBox();
  }

  completeTask(BuildContext context, TaskRegular? inputTask) async {
    await scheduleNotifications(context, task);

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
    final DateTime? picked = await Routes.showDateCalendarPicker(
      context,
      getDateTimeFromMilliseconds(task.initialDate) ?? DateTime.now(),
    );
    if (picked != null) {
      task.initialDate = picked.millisecondsSinceEpoch;
      updateDefaultRepeatLayout();
    }
  }

  scheduleNotifications(BuildContext context, TaskRegular task) async {
    if (task.time != null) {
      await NotificationService.initNotificationSystem(context);

      await NotificationService.pushRegularTask(task);

      if (task.remindBeforeTask != null)
        await NotificationService.pushBeforeRegularTask(task);
      else
        await NotificationService.deleteNotification(
            NotificationUtils.getBeforeTaskId(task));
    } else {
      await NotificationService.deleteNotification(
          NotificationUtils.getTaskId(task));
    }
  }

  Tag getTag(String id) =>
      _repoTags.getAllTags().firstWhere((element) => element.id == id);
}

