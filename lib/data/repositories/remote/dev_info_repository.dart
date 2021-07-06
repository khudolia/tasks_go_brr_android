import 'package:simple_todo_flutter/data/models/dev_info.dart';
import 'package:simple_todo_flutter/data/repositories/base/remote_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class DevInfoRepository extends RemoteRepository {

  Future<DevInfo> getDevInfo() async {
    Map<String, dynamic> data = (await getDocument(
            RemoteRepoConstants.DEV_INFO, RemoteRepoConstants.MAIN_DEV))
        .data() as Map<String, dynamic>;

    return DevInfo.fromMapObject(data);
  }
}