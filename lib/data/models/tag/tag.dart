import 'package:hive/hive.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:uuid/uuid.dart';

part 'tag.g.dart';

@HiveType(typeId: Models.TAG_ID)
class Tag {
  @HiveField(0)
  String id = "${Uuid().v1()}";

  @HiveField(1)
  late int colorCode = NotificationsSettings.LED_COLOR.value;

  @HiveField(2)
  late String title;
}