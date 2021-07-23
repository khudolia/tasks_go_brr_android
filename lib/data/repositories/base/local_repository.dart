import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_todo_flutter/data/models/day/day.dart';
import 'package:simple_todo_flutter/data/models/settings/settings.dart';
import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';
import 'package:simple_todo_flutter/resources/constants.dart';

class LocalRepository {
  late Box box;

  static init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    if(!Hive.isAdapterRegistered(Models.TASK_ID))
      Hive.registerAdapter(TaskAdapter());
    if(!Hive.isAdapterRegistered(Models.CHECK_ITEM_ID))
      Hive.registerAdapter(CheckItemAdapter());
    if(!Hive.isAdapterRegistered(Models.DAY_ID))
      Hive.registerAdapter(DayAdapter());
    if(!Hive.isAdapterRegistered(Models.TASK_REGULAR_ID))
      Hive.registerAdapter(TaskRegularAdapter());
    if(!Hive.isAdapterRegistered(Models.STATISTICS_ID))
      Hive.registerAdapter(StatisticsAdapter());
    if(!Hive.isAdapterRegistered(Models.SETTINGS_ID))
      Hive.registerAdapter(SettingsAdapter());
  }

  Future<void> initBox<E>(String box) async {
    this.box = await Hive.openBox<E>(box);
  }

  getOpenedBox(String box) {
    return this.box;
  }

  Future<void> addItem(dynamic key, dynamic object) async {
    await box.put(key, object);
  }

  Future<void> updateItem(dynamic key, dynamic object) async {
    await box.put(key, object);
  }

  dynamic getItem(dynamic key) {
    return box.get(key);
  }

  List<dynamic> getAllItems() {
    return box.values.toList();
  }

  Iterable<dynamic> getAllItemsIterable() {
    return box.values;
  }

  Future<void> deleteItem(dynamic key) async {
    await box.delete(key);
  }
}