// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 5;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings()
      ..id = fields[0] as String
      ..locale = fields[1] as String
      ..theme = fields[2] as int
      ..isNotificationsEnabled = fields[3] as bool
      ..notificationsLayout = (fields[4] as Map).cast<int, bool>()
      ..remindEveryMorningTime = fields[5] as int
      ..remindEveryEveningTime = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.locale)
      ..writeByte(2)
      ..write(obj.theme)
      ..writeByte(3)
      ..write(obj.isNotificationsEnabled)
      ..writeByte(4)
      ..write(obj.notificationsLayout)
      ..writeByte(5)
      ..write(obj.remindEveryMorningTime)
      ..writeByte(6)
      ..write(obj.remindEveryEveningTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
