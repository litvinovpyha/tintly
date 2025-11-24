// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_field.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculatorFieldAdapter extends TypeAdapter<CalculatorField> {
  @override
  final int typeId = 3;

  @override
  CalculatorField read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculatorField(
      id: fields[0] as String,
      calculatorId: fields[1] as String,
      fieldId: fields[2] as String,
      isActive: fields[3] as bool,
      position: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CalculatorField obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.calculatorId)
      ..writeByte(2)
      ..write(obj.fieldId)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculatorFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
