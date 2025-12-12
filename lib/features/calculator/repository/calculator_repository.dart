import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/calculator/models/calculator.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class CalculatorRepository extends GenericRepository<Calculator> {
  CalculatorRepository() : super('calculator');

  @override
  Future<Calculator> create(Calculator item) async {
    final newCalculator = Calculator(
      id: IdGenerator.generate(),
      userId: item.userId,
      name: item.name,
      placeholder: item.placeholder,
      isActive: item.isActive,
    );
    await box.put(newCalculator.id, newCalculator);
    return newCalculator;
  }

  Future<Calculator> createCalculatorByName(String userId, name) async {
    final newCalculator = Calculator(
      id: IdGenerator.generate(),
      userId: userId,
      name: name,
      placeholder: name,
      isActive: true,
    );
    await box.put(newCalculator.id, newCalculator);
    return newCalculator;
  }

  Future<Calculator> updateCalculatorByName(Calculator item) async {
    final newCalculator = item.copyWith(
      id: item.id,
      userId: item.userId,
      name: item.name,
      placeholder: item.placeholder,
      isActive: item.isActive,
    );
    await box.put(newCalculator.id, newCalculator);
    return newCalculator;
  }
}
