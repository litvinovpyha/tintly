import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';

class FieldService extends BaseService<Field> {
  FieldService(super.repository);

  @override
  Future<Result<Field>> create(Field item) async {
    final field = Field(
      id: generateId(),
      productName: item.productName,
      placeholder: item.placeholder,
      unitId: item.unitId,
      isActive: item.isActive,
      isChecked: item.isChecked,
    );
    return super.create(field);
  }
}
