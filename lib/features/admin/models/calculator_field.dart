import 'package:hive/hive.dart';
import '../../../core/models/base_model.dart';

part 'calculator_field.g.dart';

@HiveType(typeId: 3)
class CalculatorField extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String calculatorId;
  @HiveField(2)
  final String fieldId;
  @HiveField(3)
  final bool isActive;
  @HiveField(4)
  final int position; 

  CalculatorField({
    required this.id,
    required this.calculatorId,
    required this.fieldId,
    required this.isActive,
    required this.position,
  });
  CalculatorField copyWith({
    String? id,
    String? calculatorId,
    String? fieldId,
    bool? isActive,
    int? position,
  }) {
    return CalculatorField(
      id: id ?? this.id,
      calculatorId: calculatorId ?? this.calculatorId,
      fieldId: fieldId ?? this.fieldId,
      isActive: isActive ?? this.isActive,
      position: position ?? this.position,
    );
  }

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (calculatorId.isEmpty) errors.add('Calculator ID is required');
    if (fieldId.isEmpty) errors.add('Field ID is required');
    if (position < 0) errors.add('Position must be non-negative');
    return errors;
  }
}
