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
      ..maxDaysInRow = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Statistics obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalOfTasksInDay)
      ..writeByte(2)
      ..write(obj.daysInRow)
      ..writeByte(3)
      ..write(obj.maxDaysInRow);
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
