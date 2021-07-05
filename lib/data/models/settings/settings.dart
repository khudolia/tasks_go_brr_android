import 'package:hive/hive.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:uuid/uuid.dart';

part 'settings.g.dart';

@HiveType(typeId: Models.SETTINGS)
class Settings extends HiveObject {

  @HiveField(0)
  String id = "${Uuid().v1()}";

  @HiveField(1)
  String locale = LocalesSupported.DEVICE;

  @HiveField(2)
  int theme = Themes.DEVICE;

  @HiveField(3)
  int remindLayout = NotificationsLayout.MEDIUM;

  ///in milliseconds ot null
  @HiveField(4)
  int? remindEveryDayTime;

  ///in milliseconds or null
  @HiveField(5)
  int? remindBeforeTask;
}