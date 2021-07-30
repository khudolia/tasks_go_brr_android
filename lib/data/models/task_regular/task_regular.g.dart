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
      ..remindBeforeTask = fields[5] as int
      ..initialDate = fields[6] as int?
      ..repeatType = fields[7] as int?
      ..repeatLayout = (fields[8] as List).cast<bool>()
      ..statistic = (fields[9] as Map).cast<int, bool?>()
      ..status = fields[10] as bool;
  }

  @override
  void write(BinaryWriter writer, TaskRegular obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.remindBeforeTask)
      ..writeByte(6)
      ..write(obj.initialDate)
      ..writeByte(7)
      ..write(obj.repeatType)
      ..writeByte(8)
      ..write(obj.repeatLayout)
      ..writeByte(9)
      ..write(obj.statistic)
      ..writeByte(10)
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
