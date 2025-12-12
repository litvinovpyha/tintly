import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/calculatorField/models/calculator_field.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class CalculatorFieldRepository extends GenericRepository<CalculatorField> {
  CalculatorFieldRepository() : super('CalculatorField');

  @override
  Future<CalculatorField> create(CalculatorField item) async {
    final allCalculatorField = await getAll();

    final maxPosition = allCalculatorField
        .where((cf) => cf.calculatorId == item.calculatorId)
        .map((cf) => cf.position)
        .fold<int>(0, (a, b) => a > b ? a : b);

    final newCalculatorField = CalculatorField(
      id: IdGenerator.generate(),
      calculatorId: item.calculatorId,
      fieldId: item.fieldId,
      isActive: item.isActive,
      position: maxPosition + 1,
    );

    await box.put(newCalculatorField.id, newCalculatorField);
    return newCalculatorField;
  }

  Future<CalculatorField> createById(String calculatorId, fieldId) async {
    final allCalculatorField = await getAll();

    final maxPosition = allCalculatorField
        .where((cf) => cf.calculatorId == calculatorId)
        .map((cf) => cf.position)
        .fold<int>(0, (a, b) => a > b ? a : b);

    final newCalculatorField = CalculatorField(
      id: IdGenerator.generate(),
      calculatorId: calculatorId,
      fieldId: fieldId,
      isActive: true,
      position: maxPosition + 1,
    );

    await box.put(newCalculatorField.id, newCalculatorField);
    return newCalculatorField;
  }

  Future<List<CalculatorField>> getFieldsByCalculatorId(String calcid) async {
    final allItems = box.values;

    final filteredItems = allItems.where((item) => item.calculatorId == calcid);

    return filteredItems.toList();
  }

  Future<void> updatePositions(List<CalculatorField> items) async {
    for (int i = 0; i < items.length; i++) {
      final updated = items[i].copyWith(position: i);
      await box.put(updated.id, updated);
    }
  }
}
