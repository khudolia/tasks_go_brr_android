import 'package:flutter/material.dart';
import 'package:tasks_go_brr/data/models/settings/settings.dart';
import 'package:tasks_go_brr/data/repositories/settings_repository.dart';

class MainViewModel {
  SettingsRepository _repo = SettingsRepository();
  late Settings settings;

  initRepo(BuildContext context) async {
    settings = await _repo.initSettingsBox();
  }
}