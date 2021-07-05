import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/settings/settings.dart';
import 'package:simple_todo_flutter/data/repositories/settings_repository.dart';

class MainViewModel {
  SettingsRepository _repo = SettingsRepository();
  late Settings settings;

  initRepo(BuildContext context) async {
    settings = await _repo.initSettingsBox();
  }
}