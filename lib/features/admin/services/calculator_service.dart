import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';

class CalculatorService extends BaseService<Calculator> {
  CalculatorService(super.repository);

  @override
  Future<Result<Calculator>> create(Calculator item) async {
    final calculator = Calculator(
      id: generateId(),
      userId: item.userId,
      name: item.name,
      placeholder: item.placeholder,
      isActive: item.isActive,
    );
    return super.create(calculator);
  }
}
