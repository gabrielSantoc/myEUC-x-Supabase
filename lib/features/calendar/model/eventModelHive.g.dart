// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventModelHive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelHiveAdapter extends TypeAdapter<EventModelHive> {
  @override
  final int typeId = 1;

  @override
  EventModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModelHive(
      date: fields[0] as String,
      eventName: fields[1] as String,
      eventDescription: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventModelHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.eventName)
      ..writeByte(2)
      ..write(obj.eventDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
