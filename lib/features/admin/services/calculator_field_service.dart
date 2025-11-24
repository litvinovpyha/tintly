import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';

class CalculatorFieldService extends BaseService<CalculatorField> {
  CalculatorFieldService(super.repository);

  @override
  Future<Result<CalculatorField>> create(CalculatorField item) async {
    final allResult = await getAll();
    if (allResult.isFailure) {
      return Failure(allResult.error!);
    }

    final all = allResult.data!;
    final maxPosition = all
        .where((cf) => cf.calculatorId == item.calculatorId)
        .map((cf) => cf.position)
        .fold<int>(0, (a, b) => a > b ? a : b);

    final calculatorField = CalculatorField(
      id: generateId(),
      isActive: true,
      calculatorId: item.calculatorId,
      fieldId: item.fieldId,
      position: maxPosition + 1,
    );

    return super.create(calculatorField);
  }

  Future<void> updatePositions(
    String calculatorId,
    List<CalculatorField> fields,
  ) async {
    for (int i = 0; i < fields.length; i++) {
      final updated = fields[i].copyWith(position: i);
      await repository.update(updated);
    }
  }
}
