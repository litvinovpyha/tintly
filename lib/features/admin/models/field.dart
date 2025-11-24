import '../../../core/models/base_model.dart';
import 'package:hive/hive.dart';

part 'field.g.dart';

@HiveType(typeId: 5)
class Field extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String productName;
  @HiveField(2)
  final String? placeholder;
  @HiveField(3)
  final String unitId;
  @HiveField(4)
  final bool isActive;
  @HiveField(5)
  bool isChecked = false;

  Field({
    required this.id,
    required this.productName,
    required this.placeholder,
    required this.unitId,
    required this.isActive,
    this.isChecked = false,
  });

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (productName.isEmpty) errors.add('Product name is required');
    if (unitId.isEmpty) errors.add('Unit ID is required');
    return errors;
  }
}
