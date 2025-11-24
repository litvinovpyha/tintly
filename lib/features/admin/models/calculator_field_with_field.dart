import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/models/field.dart';

class CalculatorFieldWithField {
  final CalculatorField calculatorField;
  final Field field;

  CalculatorFieldWithField({
    required this.calculatorField,
    required this.field,
  });

  CalculatorFieldWithField copyWith({
    CalculatorField? calculatorField,
    Field? field,
  }) {
    return CalculatorFieldWithField(
      calculatorField: calculatorField ?? this.calculatorField,
      field: field ?? this.field,
    );
  }
}
