import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:simple_todo_flutter/data/models/dev_settings.dart';
import 'package:simple_todo_flutter/data/models/root_data.dart';
import 'package:simple_todo_flutter/data/models/settings/settings.dart';
import 'package:simple_todo_flutter/data/models/user_info/user_info.dart';
import 'package:simple_todo_flutter/data/repositories/remote/dev_settings_repository.dart';
import 'package:simple_todo_flutter/data/repositories/remote/user_info_repository.dart';
import 'package:simple_todo_flutter/data/repositories/settings_repository.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/utils/authentication.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_flutter/utils/locale.dart';

class SettingsViewModel {
  SettingsRepository _repo = SettingsRepository();
  UserInfoRepository _repoUser = UserInfoRepository();
  DevSettingsRepository _repoSettings = DevSettingsRepository();

  Settings settings = Settings();
  DevSettings devSettings = DevSettings();
  late UserInfo userInfo;

  initRepo() async {
    settings = await _repo.initSettingsBox();
  }

  initUserInfo() async {
    userInfo = await _repoUser.getUserInfo();
    devSettings = await _repoSettings.getDevSettings();
  }

  String? getUserPhotoPath() {
    return null;
  }

  String getCurrentLanguage() {
    return settings.locale.getLanguage();
  }

  setLocale(BuildContext context, String locale) async {
    await _repo.updateSettings(settings..locale = locale);

    if (locale != LocalesSupported.DEVICE)
      context.setLocale(Locale.fromSubtags(
          languageCode: locale.split("_")[0],
          countryCode: locale.split("_")[1]));
    else if (context.locale != context.deviceLocale &&
        context.supportedLocales.contains(context.deviceLocale))
      context.resetLocale();
  }

  setTheme(BuildContext context, int id) async {
    await _repo.updateSettings(settings..theme = id);
    Provider.of<RootData>(context, listen: false).changeTheme(id);
  }

  logoutFromAccount(BuildContext context) async {
    final rootContext =
        Provider.of<RootData>(context, listen: false).rootContext;
    if (await Authentication.signOut(context: context))
      Routes.toSplashPage(rootContext);
  }

  Future<PackageInfo> getPackageInfo() => PackageInfo.fromPlatform();
}