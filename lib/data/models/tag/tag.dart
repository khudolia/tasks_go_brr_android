import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasks_go_brr/resources/constants.dart';
import 'package:uuid/uuid.dart';

part 'tag.g.dart';

@HiveType(typeId: Models.TAG_ID)
class Tag {
  @HiveField(0)
  String id = "${Uuid().v1()}";

  @HiveField(1)
  int colorCode = Color((Random().nextDouble() * 0xFFFFFFFF).toInt())
      .withOpacity(1.0)
      .value;

  @HiveField(2)
  String title = Constants.EMPTY_STRING;
}