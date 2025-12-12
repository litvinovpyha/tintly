import 'package:equatable/equatable.dart';
import 'package:tintly/features/calculator/models/calculator.dart';

abstract class CalculatorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalculatorInitial extends CalculatorState {}

class CalculatorLoading extends CalculatorState {}

class CalculatorsLoaded extends CalculatorState {
  final List<Calculator> calculators;

  CalculatorsLoaded(this.calculators);

  @override
  List<Object?> get props => [calculators];
}

class CalculatorItemLoaded extends CalculatorState {
  final Calculator calculator;
  CalculatorItemLoaded(this.calculator);
  
  @override
  List<Object?> get props => [calculator];
}

class CalculatorError extends CalculatorState {
  final String message;

  CalculatorError(this.message);

  @override
  List<Object?> get props => [message];
}
