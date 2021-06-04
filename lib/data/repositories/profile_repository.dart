import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  setString(String key, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, id);
  }

  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  removeString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}