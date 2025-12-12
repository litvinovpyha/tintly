import 'package:tintly/features/calculatorField/models/calculator_field.dart';

abstract class CalculatorFieldEvent {}

class LoadCalculatorFields extends CalculatorFieldEvent {}

class LoadCalculatorFieldsForSession extends CalculatorFieldEvent {
  final String calculatorId;
  LoadCalculatorFieldsForSession(this.calculatorId);
}

class AddCalculatorField extends CalculatorFieldEvent {
  final CalculatorField calculatorField;
  AddCalculatorField(this.calculatorField);
}

class CreateCalculatorField extends CalculatorFieldEvent {
  final String calculatorId;
  final String fieldId;
  CreateCalculatorField(this.calculatorId, this.fieldId);
}

class UpdateCalculatorField extends CalculatorFieldEvent {
  final CalculatorField calculatorField;
  UpdateCalculatorField(this.calculatorField);
}

class DeleteCalculatorField extends CalculatorFieldEvent {
  final String id;
  DeleteCalculatorField(this.id);
}

class ReorderCalculatorFields extends CalculatorFieldEvent {
  final int oldIndex;
  final int newIndex;

  ReorderCalculatorFields(this.oldIndex, this.newIndex);
}
