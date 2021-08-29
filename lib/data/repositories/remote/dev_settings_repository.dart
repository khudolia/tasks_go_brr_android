import 'package:tasks_go_brr/data/models/dev_settings.dart';
import 'package:tasks_go_brr/data/repositories/base/remote_repository.dart';
import 'package:tasks_go_brr/resources/constants.dart';

class DevSettingsRepository extends RemoteRepository {
  Future<DevSettings> getDevSettings() async {
    Map<String, dynamic> data =
        (await getDocument(CollectionName.DEV_SETTINGS, DocumentName.SETTINGS))
            .data() as Map<String, dynamic>;

    return DevSettings.fromMapObject(data);
  }
}
