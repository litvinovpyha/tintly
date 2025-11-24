// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientAdapter extends TypeAdapter<Client> {
  @override
  final int typeId = 0;

  @override
  Client read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Client(
      id: fields[0] as String,
      name: fields[1] as String,
      photo: fields[2] as String?,
      phone: fields[3] as String?,
      birthday: fields[4] as String?,
      comment: fields[5] as String?,
      coloringTechnique: fields[6] as String?,
      haircutType: fields[7] as String?,
      serviceDuration: fields[8] as String?,
      whatsapp: fields[9] as String?,
      instagram: fields[10] as String?,
      telegram: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Client obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.photo)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.birthday)
      ..writeByte(5)
      ..write(obj.comment)
      ..writeByte(6)
      ..write(obj.coloringTechnique)
      ..writeByte(7)
      ..write(obj.haircutType)
      ..writeByte(8)
      ..write(obj.serviceDuration)
      ..writeByte(9)
      ..write(obj.whatsapp)
      ..writeByte(10)
      ..write(obj.instagram)
      ..writeByte(11)
      ..write(obj.telegram);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
