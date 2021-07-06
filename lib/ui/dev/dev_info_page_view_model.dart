import 'package:simple_todo_flutter/data/models/dev_info.dart';
import 'package:simple_todo_flutter/data/repositories/remote/dev_info_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class DevInfoPageViewModel {
  DevInfoRepository _repo = DevInfoRepository();
  late DevInfo devInfo;

  Future<void> getDevInfo() async {
    devInfo = await _repo.getDevInfo();
  }

  openLink(String url) async {
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }
}