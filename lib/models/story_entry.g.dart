// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryEntryAdapter extends TypeAdapter<StoryEntry> {
  @override
  final int typeId = 0;

  @override
  StoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryEntry(
      id: fields[0] as String,
      story: fields[1] as String,
      emotion: fields[2] as String,
      createdAt: fields[3] as DateTime,
      selectedDeficiencies: (fields[4] as List).cast<String>(),
      harmedPeople: (fields[5] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, StoryEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.story)
      ..writeByte(2)
      ..write(obj.emotion)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.selectedDeficiencies)
      ..writeByte(5)
      ..write(obj.harmedPeople);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
