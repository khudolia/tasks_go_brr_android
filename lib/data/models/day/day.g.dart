// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayAdapter extends TypeAdapter<Day> {
  @override
  final int typeId = 2;

  @override
  Day read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Day()
      ..millisecondsSinceEpoch = fields[0] as int
      ..tasks = (fields[1] as List).cast<Task>()
      ..numberOfCompletedTasks = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.millisecondsSinceEpoch)
      ..writeByte(1)
      ..write(obj.tasks)
      ..writeByte(2)
      ..write(obj.numberOfCompletedTasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
