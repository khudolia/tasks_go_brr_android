import 'package:simple_todo_flutter/resources/constants.dart';

class DevSettings {
  late String emptyPhotoURL;

  DevSettings();

  DevSettings.fromMapObject(Map<String, dynamic> map) {
    this.emptyPhotoURL = map[DevSettingsFields.EMPTY_PHOTO_URL];
  }
}
