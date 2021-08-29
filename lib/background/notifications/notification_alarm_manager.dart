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

  static init(BuildContext context) async {
    SettingsRepository _repo = SettingsRepository();
    await LocalRepository.init();
    await _repo.initSettingsBox();

    await AndroidAlarmManager.initialize();
    await NotificationService.initNotificationSystem(context);

    await AndroidAlarmManager.periodic(
        NotificationsSettings.DAILY_REMINDER_PERIOD,
        0,
        checkNotificationsForDay,
        startAt: DateTime.now().putDateAndTimeTogether(
            _repo.settings.remindEveryMorningTime.toDate()),
        wakeup: true,
        rescheduleOnReboot: true,
        exact: true);
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
}