import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class AppSettingsRepository {
  bool? isPrivacyRead;

  setPrivacyIsRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPrivacyRead = true;
    await prefs.setBool(AppSettingsFields.PRIVACY_STATUS_FIELD, true);
  }

  Future<bool> isPrivacyWasRead() async {
    if(isPrivacyRead == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return isPrivacyRead = prefs.getBool(AppSettingsFields.PRIVACY_STATUS_FIELD) ?? false;
    } else {
      return isPrivacyRead!;
    }
  }
}