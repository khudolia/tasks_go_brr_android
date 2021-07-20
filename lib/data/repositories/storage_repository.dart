import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class StorageRepository {

  Future<String> uploadUserPhoto(String id, File file) async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('${Storage.USER_INFO_PATH}')
        .child('$id')
        .child('${Storage.USER_PHOTO_PATH}')
        .child('${Storage.USER_PHOTO}');

    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}