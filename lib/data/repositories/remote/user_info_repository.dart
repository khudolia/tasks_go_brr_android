import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_go_brr/data/models/user_info/user_info.dart' as usr;
import 'package:tasks_go_brr/data/repositories/base/remote_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';

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

  Future<void> updateUserInfo(usr.UserInfo userInfo) async {
    await FirebaseFirestore.instance
        .collection(CollectionName.USER_INFO)
        .doc(userInfo.id)
        .update(userInfo.toMap());
  }
}