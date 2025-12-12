import 'package:equatable/equatable.dart';
import 'package:tintly/features/calculatorField/models/calculator_field.dart';

abstract class CalculatorFieldState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalculatorFieldInitial extends CalculatorFieldState {}

class CalculatorFieldLoading extends CalculatorFieldState {}

class CalculatorFieldsLoaded extends CalculatorFieldState {
  final List<CalculatorField> calculatorFields;
  CalculatorFieldsLoaded(this.calculatorFields);
  @override
  List<Object?> get props => [calculatorFields];
}

class CalculatorFieldError extends CalculatorFieldState {
  final String message;
  CalculatorFieldError(this.message);

  @override
  List<Object?> get props => [message];
}
