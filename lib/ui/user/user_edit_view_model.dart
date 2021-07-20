import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:simple_todo_flutter/data/models/dev_settings.dart';
import 'package:simple_todo_flutter/data/models/user_info/user_info.dart';
import 'package:simple_todo_flutter/data/repositories/remote/user_info_repository.dart';
import 'package:simple_todo_flutter/data/repositories/storage_repository.dart';

class UserEditViewModel {
  UserInfoRepository _repo = UserInfoRepository();
  StorageRepository _storage = StorageRepository();

  late UserInfo userInfo;
  late DevSettings devSettings;

  updateInfo() async {
    await _repo.updateUserInfo(userInfo);
  }

  Future pickAndUploadPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedFile != null)
      await _uploadImageToFirebase(pickedFile);
  }

  Future _uploadImageToFirebase(XFile image) async {
    userInfo.photoURL =
        await _storage.uploadUserPhoto(userInfo.id!, File(image.path));
  }
}