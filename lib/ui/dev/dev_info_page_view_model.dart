import 'package:simple_todo_flutter/data/models/dev_info.dart';
import 'package:simple_todo_flutter/data/repositories/remote/dev_info_repository.dart';
import 'package:simple_todo_flutter/utils/links.dart';

class DevInfoPageViewModel {
  DevInfoRepository _repo = DevInfoRepository();
  late DevInfo devInfo;

  Future<void> getDevInfo() async {
    devInfo = await _repo.getDevInfo();
  }

  openLink(String url) => Links.openLink(url);
}