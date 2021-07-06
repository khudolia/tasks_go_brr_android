import 'package:simple_todo_flutter/resources/constants.dart';

class DevInfo {
  late String email;
  late String name;
  late String photoPath;
  late Map<String, String> socialNetworks;

  DevInfo();

  DevInfo.fromMapObject(Map<String, dynamic> map) {
    this.email = map[DevInfoFields.EMAIL];
    this.name = map[DevInfoFields.NAME];
    this.photoPath = map[DevInfoFields.PHOTO_PATH];
    this.socialNetworks = map[DevInfoFields.SOCIAL_NETWORKS]?.cast<String, String>();
  }
}