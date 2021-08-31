import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasks_go_brr/data/models/task/task.dart';
import 'package:tasks_go_brr/data/models/task_regular/task_regular.dart';
import 'package:tasks_go_brr/main_page.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/resources/notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static initNotificationSystem(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(NotificationsSettings.ICON_NAME);

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (_) => _selectNotification(context));
  }

  static Future _selectNotification(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => MainPage()),
    );
  }

  static deleteNotification(int id) async =>
      await Notifications.delete(_flutterLocalNotificationsPlugin, id: id);

  static pushDaily(int id, int countTaskDefault, int countTaskRegular) async {
    await Notifications.tasksForDay(_flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.DAILY_REMINDER),
        countTaskDefault: countTaskDefault,
        countTaskRegular: countTaskRegular,
        id: id);
  }

  static pushDailyAfter(int id, int countTaskDefault, int countTaskRegular) async {
    await Notifications.tasksAfterDay(_flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.DAILY_REMINDER),
        countTaskDefault: countTaskDefault,
        countTaskRegular: countTaskRegular,
        id: id);
  }

  static pushSingleTask(Task task) async {
    await Notifications.task(_flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.TASK_REMINDER),
        task: task, id: NotificationUtils.getTaskId(task));
  }

  static pushBeforeSingleTask(Task task) async {
    await Notifications.beforeTask(_flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.TASK_REMINDER),
        task: task,
        id: NotificationUtils.getBeforeTaskId(task));
  }

  static pushRegularTask(TaskRegular task) async {
    await Notifications.regularTask(_flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.TASK_REMINDER),
        task: task, id: NotificationUtils.getTaskId(task));
  }

  static pushBeforeRegularTask(TaskRegular task) async {
    await Notifications.beforeRegularTask(_flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.TASK_REMINDER),
        task: task,
        id: NotificationUtils.getBeforeTaskId(task));
  }
}