import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/unit/models/unit.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class UnitRepository extends GenericRepository<Unit> {
  UnitRepository() : super('unit');

  Future<Unit> createByName(String name) async {
    final newUnit = Unit(
      id: IdGenerator.generate(),
      name: name,
      isActive: true,
      placeholder: name,
    );
    await box.put(newUnit.id, newUnit);
    return newUnit;
  }
}
  