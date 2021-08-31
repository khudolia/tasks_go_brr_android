import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:tasks_go_brr/background/notifications/notifications_service.dart';
import 'package:tasks_go_brr/data/repositories/base/local_repository.dart';
import 'package:tasks_go_brr/data/repositories/day_repository.dart';
import 'package:tasks_go_brr/data/repositories/settings_repository.dart';
import 'package:tasks_go_brr/data/repositories/task_regulalry_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:tasks_go_brr/utils/time.dart';

class NotificationAlarmManager {
  static int _id = 0;
  static bool _isInitialized = false;

  static init(BuildContext context) async {
    if (_isInitialized) return;
    SettingsRepository _repo = SettingsRepository();

    await LocalRepository.init();
    await _repo.initSettingsBox();

    _isInitialized = await AndroidAlarmManager.initialize();
    await NotificationService.initNotificationSystem(context);

    var now = DateTime.now();
    var timeBeforeDay = now
        .putDateAndTimeTogether(_repo.settings.remindEveryMorningTime.toDate());
    var timeAfterDay = now
        .putDateAndTimeTogether(_repo.settings.remindEveryEveningTime.toDate());

    scheduleNotifications(0, timeBeforeDay, now, checkNotificationsForDay);
    scheduleNotifications(1, timeAfterDay, now, checkNotificationsAfterDay);
  }

  static scheduleNotifications(
      int id, DateTime time, DateTime now, Function callback) async {
    var notificationTime = time.isAfter(now)
        ? time
        : time.add(NotificationsSettings.DAILY_REMINDER_PERIOD);
    await AndroidAlarmManager.periodic(
        NotificationsSettings.DAILY_REMINDER_PERIOD, id, callback,
        startAt: notificationTime, wakeup: true, exact: true);
  }

  static checkNotificationsForDay() async {
    DayRepository _repoDay = DayRepository();
    TaskRegularRepository _repoRegular = TaskRegularRepository();

    await LocalRepository.init();

    await _repoDay.initTaskBox(DateTime.now());
    await _repoRegular.initTaskBox();

    await NotificationService.pushDaily(_id,
        _repoDay.day.tasks.length,
        _repoRegular
            .getListOfTasksThatShouldBeShown(DateTime.now())
            .length
    );

    _id++;
  }

  static checkNotificationsAfterDay() async {
    DayRepository _repoDay = DayRepository();
    TaskRegularRepository _repoRegular = TaskRegularRepository();

    await LocalRepository.init();

    await _repoDay.initTaskBox(DateTime.now());
    await _repoRegular.initTaskBox();

    await NotificationService.pushDailyAfter(
        _id,
        _repoDay.day.tasks.where((element) => !element.status).length,
        _repoRegular
            .getListOfTasksThatShouldBeShown(DateTime.now())
            .where((element) => !element.status)
            .length);

    _id++;
  }
}