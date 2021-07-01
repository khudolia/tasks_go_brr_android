import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_todo_flutter/data/models/day/day.dart';
import 'package:simple_todo_flutter/data/models/statistics/statistics.dart';
import 'package:simple_todo_flutter/data/models/task/task.dart';
import 'package:simple_todo_flutter/data/models/task_regular/task_regular.dart';

class LocalRepository {
  late Box box;

  static init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(CheckItemAdapter());
    Hive.registerAdapter(DayAdapter());
    Hive.registerAdapter(TaskRegularAdapter());
    Hive.registerAdapter(StatisticsAdapter());
    Hive.registerAdapter(DayStatsAdapter());
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