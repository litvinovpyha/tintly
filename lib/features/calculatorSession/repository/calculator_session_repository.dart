import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/calculatorSession/models/calculator_session.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class CalculatorSessionRepository extends GenericRepository<CalculatorSession> {
  CalculatorSessionRepository() : super('CalculatorSession');

  @override
  Future<CalculatorSession> create(CalculatorSession item) async {
    final newCalculatorSession = CalculatorSession(
      id: IdGenerator.generate(),
      userId: item.userId,
      clientId: item.clientId,
      calculatorId: item.calculatorId,
      createdAt: item.createdAt,
      totalAmount: item.totalAmount,
      consumptionData: item.consumptionData,
      calculatorName: item.calculatorName,
      beforePhotos: item.beforePhotos,
      afterPhotos: item.afterPhotos,
    );
    await box.put(newCalculatorSession.id, newCalculatorSession);
    return newCalculatorSession;
  }

  Future<void> clearAllSessions() async => await box.clear();
}
