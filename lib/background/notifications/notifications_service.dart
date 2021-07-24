import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/main_page.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/notifications.dart';
import 'package:simple_todo_flutter/utils/uuid.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static initNotificationSystem(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(NotificationsSettings.ICON_NAME);

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (_) => _selectNotification(context));
  }

  static Future _selectNotification(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => MainPage()),
    );
  }

  static pushDaily(
      int id, List<String> taskTitles) async {
    await Notifications.tasksForDay(flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.DAILY_REMINDER),
        taskTitles: taskTitles, id: id);
  }

  static pushSingleTask(Task task) async {
    await Notifications.task(flutterLocalNotificationsPlugin,
        NotificationDetails(android: Channels.TASK_REMINDER),
        task: task, id: UUID.parseStringUUIDtoInt(task.id));
  }
}