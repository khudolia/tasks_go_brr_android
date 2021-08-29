import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/data/models/task_regular/task_regular.dart';
import 'package:tasks_go_brr/data/repositories/base/local_repository.dart';
import 'package:tasks_go_brr/data/repositories/settings_repository.dart';
import 'package:tasks_go_brr/data/repositories/task_regulalry_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/utils/locale.dart';
import 'package:tasks_go_brr/utils/time.dart' as time;
import 'package:tasks_go_brr/utils/uuid.dart';

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
      required int countTaskDefault,
      required int countTaskRegular}) async {

    if(!(await isNotificationsEnabled(NotificationsLayout.DAILY_REMINDER)))
      return;

    await LocaleOutOfContext.loadTranslations();

    return notification.show(
        id,
        "notification.${countTaskDefault + countTaskRegular == 0
            ? "tasks_for_day_empty"
            : "tasks_for_day"}.title"
            .tr(namedArgs: {
          "count_default": countTaskDefault.toString(),
          "count_regular": countTaskRegular.toString()
        }),
        "notification.${
            countTaskDefault + countTaskRegular == 0
                ? "tasks_for_day_empty"
                : "tasks_for_day"}.${
            "description"}"
            .tr(),
        details,
        payload: 'data');
  }

  static Future task(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id, required Task task}) async {
    if (!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS))) return;

    await LocaleOutOfContext.loadTranslations();
    await notification.cancel(id);

    return notification.schedule(
        id,
        task.title,
        task.description.isNotEmpty
            ? "description".tr() + ": ${task.description}"
            : "notification.task.description".tr(),
        task.date!.toDate().putDateAndTimeTogether(task.time!.toDate()),
        details,
        payload: 'data');
  }

  static Future beforeTask(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id, required Task task}) async {
    if (!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS))) return;

    await LocaleOutOfContext.loadTranslations();
    await notification.cancel(id);

    return notification.schedule(
        id,
        task.title,
        "notification.task_before.description".tr(namedArgs: {
          "time": time.Time.getTimeFromMilliseconds(task.time!),
        }),
        task.date!.toDate().putDateAndTimeTogether(
            time.Time.getBeforeTimeReminder(
                task.time!.toDate(), task.remindBeforeTask!.toDate())),
        details,
        payload: 'data');
  }

  static Future regularTask(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id, required TaskRegular task}) async {
    if (!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS))) return;

    await LocaleOutOfContext.loadTranslations();
    await notification.cancel(id);

    DateTime now = DateTime.now().onlyDate();
    DateTime aboveFiveYears = DateTime(
        now.year +
            NotificationsSettings.SCHEDULE_FORWARD_NOTIFICATIONS_FOR_YEARS,
        now.month,
        now.day);

    List list = [];
    for (int i = 0; i < 7; i++) {
      list.add(TaskRegularRepository()
          .isTaskShouldBeShown(task, now.add(Duration(days: i))));
    }

    for (int i = 0; i < time.Time.getDaysBetween(now, aboveFiveYears); i++) {
      DateTime day = now.add(Duration(days: i));
      if (list[i % 7]) {
        notification.schedule(
            id,
            task.title,
            task.description.isNotEmpty
                ? "description".tr() + ": ${task.description}"
                : "notification.task.description".tr(),
            day.putDateAndTimeTogether(task.time!.toDate()),
            details,
            payload: 'data');
      }
    }
  }

  static Future beforeRegularTask(
      FlutterLocalNotificationsPlugin notification, NotificationDetails details,
      {required int id, required TaskRegular task}) async {
    if (!(await isNotificationsEnabled(NotificationsLayout.ONLY_TASKS))) return;

    await LocaleOutOfContext.loadTranslations();
    await notification.cancel(id);

    DateTime now = DateTime.now().onlyDate();
    DateTime aboveFiveYears = DateTime(
        now.year +
            NotificationsSettings.SCHEDULE_FORWARD_NOTIFICATIONS_FOR_YEARS,
        now.month,
        now.day);

    List list = [];
    for (int i = 0; i < 7; i++) {
      list.add(TaskRegularRepository()
          .isTaskShouldBeShown(task, now.add(Duration(days: i))));
    }

    for (int i = 0; i < time.Time.getDaysBetween(now, aboveFiveYears); i++) {
      DateTime day = now.add(Duration(days: i));
      if (list[i % 7]) {
        notification.schedule(
            id,
            task.title,
            "notification.task_before.description".tr(namedArgs: {
              "time": time.Time.getTimeFromMilliseconds(task.time!),
            }),
            day.putDateAndTimeTogether(time.Time.getBeforeTimeReminder(
                task.time!.toDate(), task.remindBeforeTask!.toDate())),
            details,
            payload: 'data');
      }
    }
  }

  static Future<bool> isNotificationsEnabled([int? layout]) async {
    SettingsRepository _repo = SettingsRepository();
    await LocalRepository.init();
    await _repo.initSettingsBox();

    if (!_repo.settings.isNotificationsEnabled)
      return _repo.settings.isNotificationsEnabled;

    if (layout == null)
      return _repo.settings.isNotificationsEnabled;
    else
      return _repo.settings.notificationsLayout[layout]!;
  }
}

class NotificationUtils {
  static int getTaskId(dynamic task) => UUID.parseStringUUIDtoInt(task.id);
  static int getBeforeTaskId(dynamic task) => - UUID.parseStringUUIDtoInt(task.id);
}