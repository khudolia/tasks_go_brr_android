import 'package:tasks_go_brr/data/models/dev_info.dart';
import 'package:tasks_go_brr/data/repositories/base/remote_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';

class DevInfoRepository extends RemoteRepository {

  Future<DevInfo> getDevInfo() async {
    Map<String, dynamic> data = (await getDocument(
        CollectionName.DEV_INFO, DocumentName.MAIN_DEV))
        .data() as Map<String, dynamic>;

    return DevInfo.fromMapObject(data);
  }
}