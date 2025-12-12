// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculatorSessionAdapter extends TypeAdapter<CalculatorSession> {
  @override
  final int typeId = 2;

  @override
  CalculatorSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculatorSession(
      id: fields[0] as String,
      userId: fields[1] as String,
      clientId: fields[2] as String,
      calculatorId: fields[3] as String,
      createdAt: fields[4] as DateTime,
      totalAmount: fields[5] as double,
      consumptionData: (fields[6] as Map?)?.cast<String, double>(),
      calculatorName: fields[7] as String?,
      beforePhotos: (fields[8] as List?)?.cast<String>(),
      afterPhotos: (fields[9] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CalculatorSession obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.clientId)
      ..writeByte(3)
      ..write(obj.calculatorId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.totalAmount)
      ..writeByte(6)
      ..write(obj.consumptionData)
      ..writeByte(7)
      ..write(obj.calculatorName)
      ..writeByte(8)
      ..write(obj.beforePhotos)
      ..writeByte(9)
      ..write(obj.afterPhotos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculatorSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
