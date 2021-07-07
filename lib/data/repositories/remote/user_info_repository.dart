import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_todo_flutter/data/models/user_info/user_info.dart' as usr;
import 'package:simple_todo_flutter/data/repositories/base/remote_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class UserInfoRepository extends RemoteRepository {
  Future<usr.UserInfo> getUserInfo() async {
    Map<String, dynamic> data = (await getDocument(
            CollectionName.USER_INFO, FirebaseAuth.instance.currentUser!.uid))
        .data() as Map<String, dynamic>;

    return usr.UserInfo.fromMapObject(data);
  }

  Future<void> addUserInfo(usr.UserInfo userInfo) async {
    await FirebaseFirestore.instance
        .collection(CollectionName.USER_INFO)
        .doc(userInfo.id)
        .set(userInfo.toMap());
  }
}