import 'package:tasks_go_brr/resources/constants.dart';

class DevSettings {
  late String emptyPhotoURL;

  DevSettings();

  DevSettings.fromMapObject(Map<String, dynamic> map) {
    this.emptyPhotoURL = map[DevSettingsFields.EMPTY_PHOTO_URL];
  }
}
