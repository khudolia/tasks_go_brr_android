import 'package:hive/hive.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:uuid/uuid.dart';

part 'settings.g.dart';

@HiveType(typeId: Models.SETTINGS_ID)
class Settings extends HiveObject {

  @HiveField(0)
  String id = "${Uuid().v1()}";

  @HiveField(1)
  String locale = LocalesSupported.DEVICE;

  @HiveField(2)
  int theme = Themes.DEVICE;

  @HiveField(3)
  bool isNotificationsEnabled = true;

  ///int NotificationsLayout.type: isEnabled
  @HiveField(4)
  Map<int, bool> notificationsLayout = {
    NotificationsLayout.ONLY_TASKS: true,
    NotificationsLayout.DAILY_REMINDER: false,
    NotificationsLayout.ACTIVITY_REMINDER: false,
  };

  ///in milliseconds ot null
  @HiveField(5)
  int remindEveryMorningTime = DateTime(0, 0, 0, 10, 00).millisecondsSinceEpoch;

  @HiveField(6)
  int remindEveryEveningTime = DateTime(0, 0, 0, 20, 00).millisecondsSinceEpoch;

  ///in milliseconds or null
  @HiveField(7)
  int remindBeforeTask = DateTime(0, 0, 0, 0, 30).millisecondsSinceEpoch;
}