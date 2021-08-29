import 'package:tasks_go_brr/resources/constants.dart';

class UserInfo {
  String? id;
  String? name;
  String? photoURL;
  String? email;

  UserInfo({required this.id,
    required this.name,
    required this.photoURL,
    required this.email});

  UserInfo.fromMapObject(Map<String, dynamic> map) {
    this.id = map[UserInfoFields.ID];
    this.name = map[UserInfoFields.NAME];
    this.photoURL = map[UserInfoFields.PHOTO_URL];
    this.email = map[UserInfoFields.EMAIL];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      UserInfoFields.ID: id,
      UserInfoFields.NAME: name,
      UserInfoFields.PHOTO_URL: photoURL,
      UserInfoFields.EMAIL: email,
    };
  }
}