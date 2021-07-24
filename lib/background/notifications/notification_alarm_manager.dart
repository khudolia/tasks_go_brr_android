import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/background/notifications/notifications_service.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/data/repositories/day_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class NotificationAlarmManager {
  static int _id = 0;

  static init(BuildContext context) async {
    await AndroidAlarmManager.initialize();
    await NotificationService.initNotificationSystem(context);

    /*await AndroidAlarmManager.periodic(
        NotificationsSettings.DAILY_REMINDER_PERIOD, 0, checkNotificationsForDay);*/
  }

  static checkNotificationsForDay() async {
    DayRepository _repoDay = DayRepository();

    await LocalRepository.init();
    await _repoDay.initTaskBox(DateTime.now());

    await NotificationService.pushDaily(_id,
        _repoDay.day.tasks.map((e) => e.title).toList());

    _id++;
  }
}