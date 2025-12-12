import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class FieldRepository extends GenericRepository<Field> {
  FieldRepository() : super('field');

  @override
  Future<Field> create(Field item) async {
    final newField = Field(
      id: IdGenerator.generate(),
      name: item.name,
      placeholder: item.placeholder,
      unitId: item.unitId,
      isActive: item.isActive,
      isChecked: item.isChecked,
    );
    await box.put(newField.id, newField);
    return newField;
  }

  @override
  Future<Field?> update(Field item) async {
    await box.put(item.id, item);
    return item;
  }
}
