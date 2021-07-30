import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/data/repositories/settings_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/utils/locale.dart';
import 'package:simple_todo_flutter/utils/time.dart' as time;
import 'package:simple_todo_flutter/utils/uuid.dart';

class Channels {
  static const DAILY_REMINDER = AndroidNotificationDetails(
      "0",
      "Daily reminder",
      "In this channel notifications appears daily in the specific time",
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      ledColor: NotificationsSettings.LED_COLOR,
      ledOnMs: 2,
      ledOffMs: 1);

  static const TASK_REMINDER = AndroidNotificationDetails(
      "1",
      "Task reminder",
      "In this channel notifications appears only for tasks",
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      ledColor: NotificationsSettings.LED_COLOR,
      ledOnMs: 2,
      ledOffMs: 1,);
}

class Notifications {
  static Future delete(FlutterLocalNotificationsPlugin notification,
          {required int id}) async =>
      await notification.cancel(id);

  static Future tasksForDay(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id,
      required List<String> taskTitlesDefault,
      required List<String> taskTitlesRegular}) async {
    print(await isNotificationsEnabled(NotificationsLayout.DAILY_REMINDER));
    if(!(await isNotificationsEnabled(NotificationsLayout.DAILY_REMINDER)))
      return;

    var allTasks = taskTitlesDefault.length + taskTitlesRegular.length;
    String stringTasks = taskTitlesDefault.join(", ");

    await LocaleOutOfContext.loadTranslations();

    return notification.show(
        id,
        "notification.${allTasks == 0
            ? "tasks_for_day_empty" 
            : "tasks_for_day"}.title"
            .tr(namedArgs: {
          "count_default": taskTitlesDefault.length.toString(),
          "count_regular": taskTitlesRegular.length.toString()
        }),
        "notification.${
            allTasks == 0
                ? "tasks_for_day_empty"
                : "tasks_for_day"}.${
            stringTasks.length > NotificationsSettings.MAX_STRING_LENGTH_OF_TASKS_IN_DESCRIPTION
                ? "description"
                : "description_tasks"}"
            .tr(namedArgs: {"tasks": taskTitlesDefault.join(" ")}),
        details,
        payload: 'data');
  }

  static Future task(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id,
      required Task task}) async {

    if(!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS)))
      return;

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

  static Future beforeTask(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id, required Task task}) async {

    if(!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS)))
      return;
    await LocaleOutOfContext.loadTranslations();

    await notification.cancel(id);

    return notification.schedule(
        id,
        "notification.task_before.title".tr(namedArgs: {
          "task": task.title,
        }),
        "notification.task_before.description".tr(namedArgs: {
          "time": time.Time.getTimeFromMilliseconds(task.time!),
          "before_time": time.Time.getBeforeTimeFromMilliseconds(
              time.Time.getBeforeTimeReminder(
                      task.time!.toDate(), DateTime.now())
                  .millisecondsSinceEpoch)
        }),
        task.date!.toDate().putDateAndTimeTogether(
            time.Time.getBeforeTimeReminder(
                task.time!.toDate(), task.remindBeforeTask!.toDate())),
        details,
        payload: 'data');
  }

  static Future regularTask(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id,
        required TaskRegular task}) async {

    if(!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS)))
      return;

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
        DateTime.now().putDateAndTimeTogether(task.time!.toDate()),
        details,
        payload: 'data');
  }

  static Future beforeRegularTask(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id, required TaskRegular task}) async {

    if(!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS)))
      return;

    await LocaleOutOfContext.loadTranslations();

    await notification.cancel(id);

    return notification.schedule(
        id,
        "notification.task_before.title".tr(namedArgs: {
          "task": task.title,
        }),
        "notification.task_before.description".tr(namedArgs: {
          "time": time.Time.getTimeFromMilliseconds(task.time!),
          "before_time": time.Time.getBeforeTimeFromMilliseconds(
              time.Time.getBeforeTimeReminder(
                      task.time!.toDate(), DateTime.now())
                  .millisecondsSinceEpoch)
        }),
        DateTime.now().putDateAndTimeTogether(time.Time.getBeforeTimeReminder(
            task.time!.toDate(), task.remindBeforeTask!.toDate())),
        details,
        payload: 'data');
  }

  static Future<bool> isNotificationsEnabled([int? layout]) async {
    SettingsRepository _repo = SettingsRepository();
    await LocalRepository.init();
    await _repo.initSettingsBox();

    if(!_repo.settings.isNotificationsEnabled)
      return _repo.settings.isNotificationsEnabled;

    if(layout == null)
      return _repo.settings.isNotificationsEnabled;
    else
      return _repo.settings.notificationsLayout[layout]!;
  }
}

class NotificationUtils {
  static int getTaskId(dynamic task) => UUID.parseStringUUIDtoInt(task.id);
  static int getBeforeTaskId(dynamic task) => - UUID.parseStringUUIDtoInt(task.id);
}