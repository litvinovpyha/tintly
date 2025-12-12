import 'package:tintly/features/calculator/models/calculator.dart';

abstract class CalculatorEvent {}

class LoadCalculators extends CalculatorEvent {}

class LoadCalculatorById extends CalculatorEvent {
  final String id;
  LoadCalculatorById(this.id);
}

class AddCalculator extends CalculatorEvent {
  final Calculator calculator;
  AddCalculator(this.calculator);
}

class UpdateCalculator extends CalculatorEvent {
  final Calculator calculator;
  UpdateCalculator(this.calculator);
}

class UpdateCalculatorByName extends CalculatorEvent {
  final String newName;
  final String id;
  UpdateCalculatorByName(this.id, this.newName);
}

class DeleteCalculator extends CalculatorEvent {
  final String id;
  DeleteCalculator(this.id);
}

class CreateCalculatorByName extends CalculatorEvent {
  final String userId;
  final String name;
  CreateCalculatorByName(this.userId, this.name);
}
