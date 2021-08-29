import 'package:tasks_go_brr/data/models/dev_info.dart';
import 'package:tasks_go_brr/data/repositories/remote/dev_info_repository.dart';
import 'package:tasks_go_brr/utils/links.dart';

class DevInfoPageViewModel {
  DevInfoRepository _repo = DevInfoRepository();
  late DevInfo devInfo;

  Future<void> getDevInfo() async {
    devInfo = await _repo.getDevInfo();
  }

  openLink(String url) => Links.openLink(url);
}