// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatisticsAdapter extends TypeAdapter<Statistics> {
  @override
  final int typeId = 4;

  @override
  Statistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Statistics()
      ..id = fields[0] as String
      ..goalOfTasksInDay = fields[1] as int
      ..daysInRow = fields[2] as int
      ..maxDaysInRow = fields[3] as int
      ..days = (fields[4] as List).cast<DayStats>();
  }

  @override
  void write(BinaryWriter writer, Statistics obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalOfTasksInDay)
      ..writeByte(2)
      ..write(obj.daysInRow)
      ..writeByte(3)
      ..write(obj.maxDaysInRow)
      ..writeByte(4)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayStatsAdapter extends TypeAdapter<DayStats> {
  @override
  final int typeId = 5;

  @override
  DayStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayStats()
      ..date = fields[0] as int
      ..completedDefaultTasks = fields[1] as int
      ..completedRegularTasks = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, DayStats obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.completedDefaultTasks)
      ..writeByte(2)
      ..write(obj.completedRegularTasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
