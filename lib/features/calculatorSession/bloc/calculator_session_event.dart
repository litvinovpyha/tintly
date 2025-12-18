import 'package:tintly/features/calculatorSession/models/calculator_session.dart';
import 'package:tintly/shared/enums/history_period.dart';

abstract class CalculatorSessionEvent {}

class LoadCalculatorSessions extends CalculatorSessionEvent {}

class LoadCalculatorSessionItem extends CalculatorSessionEvent {
  final String id;
  LoadCalculatorSessionItem(this.id);
}

class AddCalculatorSession extends CalculatorSessionEvent {
  final String userId;
  final String? clientId;
  final String calculatorId;
  final double totalAmount;
  final String calculatorName;
  AddCalculatorSession({
    required this.userId,
    this.clientId,
    required this.calculatorId,
    required this.totalAmount,
    required this.calculatorName,
  });
}

class UpdateCalculatorSession extends CalculatorSessionEvent {
  final CalculatorSession calculatorSession;
  UpdateCalculatorSession(this.calculatorSession);
}

class DeleteCalculatorSession extends CalculatorSessionEvent {
  final String id;
  DeleteCalculatorSession(this.id);
}

class ClearAllSessions extends CalculatorSessionEvent {}

class LoadSessionsByPeriod extends CalculatorSessionEvent {
  final HistoryPeriod period;

  LoadSessionsByPeriod(this.period);
}

class LoadSessionsByType extends CalculatorSessionEvent {
  final String calculatorName;

  LoadSessionsByType(this.calculatorName);
}
