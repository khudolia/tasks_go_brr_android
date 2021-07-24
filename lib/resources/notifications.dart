import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/utils/locale.dart';
import 'package:simple_todo_flutter/utils/time.dart';

class Channels {
  static const DAILY_REMINDER = AndroidNotificationDetails(
      "0",
      "Daily reminder",
      "In this channel notifications appears daily in the specific time",
      importance: Importance.max,
      priority: Priority.max);

  static const TASK_REMINDER = AndroidNotificationDetails(
      "1",
      "Task reminder",
      "In this channel notifications appears only for tasks",
      importance: Importance.max,
      priority: Priority.max);
}

class Notifications {
  static Future tasksForDay(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id,
      required List<String> taskTitles}) async {
    await LocaleOutOfContext.loadTranslations();
    return notification.show(
        id,
        "notification.${taskTitles.length == 0
            ? "tasks_for_day_empty" 
            : "tasks_for_day"}.title"
            .tr(namedArgs: {"count": taskTitles.length.toString()}),
        "notification.${taskTitles.length == 0
            ? "tasks_for_day_empty" 
            : "tasks_for_day"}.description"
            .tr(namedArgs: {"tasks": taskTitles.join(" ")}),
        details,
        payload: 'data');
  }

  static Future task(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id,
      required Task task}) async {
    await LocaleOutOfContext.loadTranslations();

    await notification.cancel(id);

    return notification.schedule(
        id,
        "notification.task.title"
            .tr(namedArgs: {"task": task.title}),
        task.description.isNotEmpty
            ? "description".tr() + ": ${task.description}"
            : task.checkList.isNotEmpty
                ? "checklist".tr() +
                    ": ${task.checkList.map((e) => e.text).join(" ")}"
                : "notification.task.description".tr(),
        task.date!.toDate().putDateAndTimeTogether(task.time!.toDate()),
        details,
        payload: 'data');
  }
}