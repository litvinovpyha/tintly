import '../../../core/models/base_model.dart';
import 'package:hive/hive.dart';

part 'unit.g.dart';

@HiveType(typeId: 7)
class Unit extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String unitName;
  @HiveField(2)
  final bool isActive;
  @HiveField(3)
  final String? placeholder;

  Unit({
    required this.id,
    required this.unitName,
    required this.isActive,
    required this.placeholder,
  });

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (unitName.isEmpty) errors.add('Unit name is required');
    return errors;
  }
}
