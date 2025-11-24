import 'package:tintly/core/controllers/base_controller.dart';
import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/features/admin/services/field_service.dart';

class FieldController extends BaseController<Field> {
  FieldController(super.service);

  FieldService get fieldService => service as FieldService;
  Future<void> create(Field field) async {
    await service.create(field);
  }

  Future<List<Field>> getAll() async {
    final result = await service.getAll();
    if (result.isFailure) {
      throw Exception(result.error);
    }
    return result.data!;
  }

  Future<void> createField({
    required String name,
    required String unitId,
    required String placeholder,
    required bool isChecked,
  }) async {
    final field = Field(
      id: '',
      productName: name.trim(),
      unitId: unitId,
      placeholder: placeholder,
      isActive: true,
      isChecked: isChecked,
    );
    await create(field);
  }

  Future<void> delete(String id) async {
    await service.delete(id);
    await loadItems();
  }
}
