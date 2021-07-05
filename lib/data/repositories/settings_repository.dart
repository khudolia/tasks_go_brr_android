import 'package:simple_todo_flutter/data/models/settings/settings.dart';
import 'package:simple_todo_flutter/data/repositories/base/local_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class SettingsRepository extends LocalRepository {

  Future<Settings> initSettingsBox() async {
    await initBox<Settings>(Repo.SETTINGS);
    var settings = await initSettings();

    return settings;
  }

  Future<Settings> initSettings() async {
    return getSettingsFromDB() ?? await addSettings(Settings());
  }

  Future<Settings> addSettings(Settings settings) async {
    await addItem(settings.id, settings);
    return settings;
  }

  Future<void> updateSettings(Settings settings) async {
    await updateItem(settings.id, settings);
  }

  Settings? getSettingsFromDB() {
    return getAllItems().isNotEmpty ? getAllItems().first : null;
  }
}