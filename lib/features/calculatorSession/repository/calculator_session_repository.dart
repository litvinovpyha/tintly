import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/calculatorSession/models/calculator_session.dart';
import 'package:tintly/shared/enums/history_period.dart';
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

  Future<List<CalculatorSession>> getByPeriod(HistoryPeriod period) async {
    final now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case HistoryPeriod.today:
        startDate = DateTime(now.year, now.month, now.day);
        break;

      case HistoryPeriod.week:
        startDate = now.subtract(const Duration(days: 7));
        break;

      case HistoryPeriod.month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;

      case HistoryPeriod.halfYear:
        startDate = DateTime(now.year, now.month - 6, now.day);
        break;

      case HistoryPeriod.year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    return box.values.where((s) => s.createdAt.isAfter(startDate)).toList();
  }
}
