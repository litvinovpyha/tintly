import 'package:equatable/equatable.dart';
import 'package:tintly/features/calculatorSession/models/calculator_session.dart';

abstract class CalculatorSessionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalculatorSessionInitial extends CalculatorSessionState {}

class CalculatorSessionLoading extends CalculatorSessionState {}

class CalculatorSessionItemLoaded extends CalculatorSessionState {
  final CalculatorSession calculatorSession;
  CalculatorSessionItemLoaded(this.calculatorSession);
}

class CalculatorSessionLoaded extends CalculatorSessionState {
  final List<CalculatorSession> calculatorSession;
  CalculatorSessionLoaded(this.calculatorSession);
  @override
  List<Object?> get props => [CalculatorSession];
}

class CalculatorSessionError extends CalculatorSessionState {
  final String message;
  CalculatorSessionError(this.message);

  @override
  List<Object?> get props => [message];
}
