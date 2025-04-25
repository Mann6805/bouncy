// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensordata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensordataAdapter extends TypeAdapter<Sensordata> {
  @override
  final int typeId = 0;

  @override
  Sensordata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sensordata(
      acex: fields[0] as double,
      acey: fields[1] as double,
      gyroz: fields[2] as double,
      timestamp: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sensordata obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.acex)
      ..writeByte(1)
      ..write(obj.acey)
      ..writeByte(2)
      ..write(obj.gyroz)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensordataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
