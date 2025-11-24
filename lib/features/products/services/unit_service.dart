import 'package:tintly/features/products/models/unit.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';

class UnitService extends BaseService<Unit> {
  UnitService(super.repository);

  @override
  Future<Result<Unit>> create(Unit item) async {
    final unit = Unit(
      id: generateId(),
      unitName: item.unitName,
      isActive: item.isActive,
      placeholder: item.placeholder,
    );
    return super.create(unit);
  }

  Future<Result<Unit>> createByName(String name) async {
    if (name.trim().isEmpty) {
      return Failure('Название единицы измерения не может быть пустым');
    }

    final unit = Unit(
      id: generateId(),
      unitName: name.trim(),
      isActive: true,
      placeholder: "",
    );
    return super.create(unit);
  }
}
