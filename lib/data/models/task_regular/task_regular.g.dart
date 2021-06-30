// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_regular.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskRegularAdapter extends TypeAdapter<TaskRegular> {
  @override
  final int typeId = 3;

  @override
  TaskRegular read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskRegular()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..description = fields[2] as String
      ..checkList = (fields[3] as List).cast<CheckItem>()
      ..time = fields[4] as int?
      ..initialDate = fields[5] as int?
      ..repeatType = fields[6] as int?
      ..repeatLayout = (fields[7] as List).cast<bool>()
      ..statistic = (fields[8] as Map).cast<int, bool?>()
      ..status = fields[9] as bool;
  }

  @override
  void write(BinaryWriter writer, TaskRegular obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.checkList)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.initialDate)
      ..writeByte(6)
      ..write(obj.repeatType)
      ..writeByte(7)
      ..write(obj.repeatLayout)
      ..writeByte(8)
      ..write(obj.statistic)
      ..writeByte(9)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskRegularAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
